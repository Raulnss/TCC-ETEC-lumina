<?php
// ESSE CÓDIGO RODA NO CRON JOB DO SERVIDOR

// Permitir CORS (opcional, importante se for acessar via web)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");

date_default_timezone_set('America/Sao_Paulo');

// Corrige warning verificando se REQUEST_METHOD está setado
if (php_sapi_name() !== 'cli' && isset($_SERVER['REQUEST_METHOD']) && $_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit();
}

require __DIR__ . '/vendor/autoload.php';

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

require __DIR__ . '/../conecta.php';

$firebaseJsonPath = __DIR__ . '/firebase_credentials.json';

$enviadas = 0;
$falhas = 0;
$erros = [];

try {
    $factory = (new Factory)->withServiceAccount($firebaseJsonPath);
    $messaging = $factory->createMessaging();
} catch (\Throwable $e) {
    $mensagemErro = "Erro ao iniciar Firebase: " . $e->getMessage();
    error_log($mensagemErro);
    $erros[] = $mensagemErro;

    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Erro ao iniciar Firebase',
        'errors' => $erros
    ]);
    exit();
}

try {
    $conn = getConnection();
} catch (\Throwable $e) {
    $mensagemErro = "Erro ao conectar ao banco de dados: " . $e->getMessage();
    error_log($mensagemErro);
    $erros[] = $mensagemErro;

    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Erro ao conectar ao banco',
        'errors' => $erros
    ]);
    exit();
}

$hoje = new DateTime('now', new DateTimeZone('America/Sao_Paulo'));

function mapDuracaoParaDias($duracao_media) {
    $mapeamento = [
        "Menos de 21 dias" => 20,
        "Entre 21 e 35 dias" => 28,
        "Mais de 35 dias" => 40,
        "Não sei" => 28
    ];
    return $mapeamento[$duracao_media] ?? 28;
}

// Query para pegar última menstruação de cada usuário com token válido
$sql = "
    SELECT 
        u.cd_id AS user_id,
        ut.fcm_token,
        i.ds_duracao_media_ciclo,
        ult.dt_dias_mestruacao
    FROM tb_user u
    JOIN user_tokens ut ON ut.user_id = u.cd_id
    JOIN tb_informacoes i ON i.cd_user = u.cd_id
    JOIN (
        SELECT cd_user, MAX(dt_dias_mestruacao) AS dt_dias_mestruacao
        FROM tb_calendario
        GROUP BY cd_user
    ) ult ON ult.cd_user = u.cd_id
    WHERE ut.fcm_token IS NOT NULL AND TRIM(ut.fcm_token) != ''
";

try {
    $stmt = $conn->prepare($sql);
    $stmt->execute();
    $usuarios = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (\Throwable $e) {
    $mensagemErro = "Erro ao buscar usuários: " . $e->getMessage();
    error_log($mensagemErro);
    $erros[] = $mensagemErro;

    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Erro ao buscar usuários',
        'errors' => $erros
    ]);
    exit();
}

foreach ($usuarios as $usuario) {
    $userId = $usuario['user_id'];
    $token = $usuario['fcm_token'];
    $duracao_media = $usuario['ds_duracao_media_ciclo'];
    $ultimaData = $usuario['dt_dias_mestruacao'];

    if (!$ultimaData || !$token) {
        // Se faltar data ou token, pula o usuário
        continue;
    }

    // Tenta criar objeto DateTime para a última menstruação
    try {
        $dataUltima = new DateTime($ultimaData, new DateTimeZone('America/Sao_Paulo'));
    } catch (Exception $e) {
        $mensagemErro = "Formato inválido da data para usuário {$userId}: " . $ultimaData;
        error_log($mensagemErro);
        $erros[] = $mensagemErro;
        continue;
    }

    $diasEstimados = mapDuracaoParaDias($duracao_media);
    $proximaMenstruacao = clone $dataUltima;
    $proximaMenstruacao->modify("+{$diasEstimados} days");

    $diff = $hoje->diff($proximaMenstruacao);
    $diasRestantes = (int)$diff->format('%r%a'); // %r para pegar o sinal

    if ($diasRestantes >= 0 && $diasRestantes <= 1) {
        $titulo = "Lembrete";
        $mensagem = $diasRestantes === 0
            ? "Sua menstruação está prevista para hoje. Cuide-se!"
            : "Sua menstruação está prevista para amanhã. Cuide-se!";

        $message = CloudMessage::withTarget('token', $token)
            ->withNotification(Notification::create($titulo, $mensagem));

        try {
            $messaging->send($message);
            $enviadas++;
        } catch (\Throwable $e) {
            $mensagemErro = "Erro ao enviar notificação para usuário {$userId}: " . $e->getMessage();
            error_log($mensagemErro);
            $erros[] = $mensagemErro;
            $falhas++;
        }
    }
}

echo json_encode([
    "success" => true,
    "message" => "Verificação completada.",
    "notificacoes_enviadas" => $enviadas,
    "falhas" => $falhas,
    "errors" => $erros
]);