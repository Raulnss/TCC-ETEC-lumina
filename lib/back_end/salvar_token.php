<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");

// Responde pré-flight automaticamente
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit();
}

include 'conecta.php';
$conn = getConnection();

$dados = array(
    "user_id" => $_POST['user_id'] ?? null,
    "fcm_token" => $_POST['fcm_token'] ?? null
);
$dados = array_map('trim', $dados);

try {
    if (empty($dados['user_id']) || empty($dados['fcm_token'])) {
        throw new Exception("Parâmetros inválidos ou ausentes.");
    }

    // Verifica se o usuário existe
    $checkUser = $conn->prepare("SELECT cd_id FROM tb_user WHERE cd_id = :user_id");
    $checkUser->bindParam(":user_id", $dados['user_id'], PDO::PARAM_INT);
    $checkUser->execute();

    if ($checkUser->rowCount() === 0) {
        throw new Exception("Usuário não encontrado.");
    }

    // Atualiza ou insere token
    $stmt = $conn->prepare("
        INSERT INTO tb_user_tokens (user_id, fcm_token)
        VALUES (:user_id, :fcm_token)
        ON DUPLICATE KEY UPDATE fcm_token = :fcm_token_atualizado, updated_at = CURRENT_TIMESTAMP
    ");
    $stmt->execute([
        ":user_id" => $dados['user_id'],
        ":fcm_token" => $dados['fcm_token'],
        ":fcm_token_atualizado" => $dados['fcm_token']
    ]);

    $response = [
        "success" => true,
        "message" => "Token salvo com sucesso."
    ];
} catch (Throwable $th) {
    $response = [
        "success" => false,
        "message" => "Erro: " . $th->getMessage()
    ];
}

echo json_encode($response);