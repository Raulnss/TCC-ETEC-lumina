<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type");
if (strpos($_SERVER['CONTENT_TYPE'], 'application/json') === 0) {
    $_POST = json_decode(file_get_contents("php://input"), true);
}
include 'conecta.php';
$operacao = $_POST['operacao'];
$msg = "";
switch ($operacao) {
    case "cadastra_nome":
        cadastra_nome($_POST['nome'],$_POST['id']);
        break;
    case "Pega_nome":
        pega_nome($_POST['id']);
        break;
    case "atualiza_senha":
        atualiza_senha($_POST['senha'],$_POST['id']);
        break;
    case "cadastro_regularidade_ciclo":
        cadastro_regularidade_ciclo($_POST['opcao'],$_POST['id']);
        break;
    case "cadastro_duracao_media_ciclo":
        cadastro_duracao_media_ciclo($_POST['opcao'],$_POST['id']);
        break;
    case "cadastro_nivel_energia_ciclo":
        cadastro_nivel_energia_ciclo($_POST['opcao'],$_POST['id']);
        break;
    case "cadastro_humor_antes_mestruacao":
        cadastro_humor_antes_mestruacao($_POST['opcao'],$_POST['id']);
        break;
    case "cadastro_duracao_media_mestruacao":
        cadastro_duracao_media_mestruacao($_POST['opcao'],$_POST['id']);
        break;
    case "Pega_nome_email":
        Pega_nome_email($_POST['id']);
        break;
    case "Calendario_carregar_dados":
        Calendario_carregar_dados($_POST['id']);
        break;
    case "Calendario_salvar_dia":
        Calendario_salvar_dia($_POST['dt_dias_mestruacao'],$_POST['cd_user']);
        break;
    case "Calendario_deletar_dia":
        Calendario_deletar_dia($_POST['dt_dias_mestruacao'],$_POST['cd_user']);
        break;
    case "Calendario_pegar_ano":
        data_atual();
        break;
    case "Autocuidado_salvar":
        Autocuidado_salvar($_POST['id'], $_POST['data'], $_POST['sintomas'], $_POST['humores'], $_POST['fluxo'], $_POST['anotacao']);
    break;
    case "Autocuidado_carregar":
        Autocuidado_carregar($_POST['id']);
        break;
    case 'dias_para_proxima_menstruacao':
        dias_para_proxima_menstruacao($_POST['id']);
        break;
    case 'estatisticas_caregamento':
        estatisticas_caregamento($_POST['id']);
        break;
    case 'Calendario_prever_dias':
        Calendario_prever_dias($id);
        break;
    default:
        $msg = "Nenhuma solicitação encontrada.";
}
function cadastra_nome($nome,$id) {
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;
    $nome = trim($nome);
    if (empty($id) || empty($nome)) {
        $msg = "Erro: nome ou id vazio.";
        return;
    }
    try {
        $query = $conn->prepare("UPDATE tb_user SET nm_user = :nome WHERE cd_id = :cd LIMIT 1");
        $query->execute(array(
            ":nome" => $nome,
            ":cd" => $id
        ));
        $veri = $conn->prepare('SELECT * FROM tb_informacoes WHERE cd_user = :cd');
        $veri->bindParam(':cd', $id, PDO::PARAM_STR);
        $veri->execute();
        $smtd = $veri->fetch(PDO::FETCH_ASSOC);
        if(!$smtd AND $veri->rowCount() == 0){
            $inert = $conn->prepare("INSERT INTO tb_informacoes(cd_user) VALUES(:cd)");
            $inert->bindParam(':cd', $id, PDO::PARAM_STR);
            $inert->execute();
        }
        $msg = "sucesso";
    } catch(\Throwable $th) {
       $msg = "Error: " . $th->getMessage(); 
    }
}
function pega_nome($id) {
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;
    try {
        $query = $conn->prepare("SELECT nm_user FROM tb_user WHERE cd_id = :cd LIMIT 1");
        $query->execute(array(
            ":cd" => $id
        ));
        $dado = $query->fetch(PDO::FETCH_ASSOC);
        $msg = $dado['nm_user'];
    } catch(\Throwable $th) {
       $msg = "Error: " . $th->getMessage(); 
    }
}
function atualiza_senha($senha,$id) {
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;
    $senha = trim($senha);
    $senha = password_hash($senha,PASSWORD_DEFAULT);
    try {
        $query = $conn->prepare("UPDATE tb_user SET cd_senha = :senha WHERE cd_id = :cd LIMIT 1");
        $query->execute(array(
            ":senha" => $senha,
            ":cd" => $id
        ));
        $msg = "sucesso";
    } catch(\Throwable $th) {
       $msg = "Error: " . $th->getMessage(); 
    }
}
function cadastro_regularidade_ciclo($opcao,$id){
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;
    $opcao = trim($opcao);
    if (empty($id) || empty($opcao)) {
        $msg = "Erro: nome ou id vazio.";
        return;
    }
    try {
        $query = $conn->prepare("UPDATE tb_informacoes SET ds_regularidade_ciclo = :opcao WHERE cd_user = :cd LIMIT 1");
        $query->execute(array(
            ":opcao" => $opcao,
            ":cd" => $id
        ));
        $msg = "sucesso";
    } catch(\Throwable $th) {
       $msg = "Error: " . $th->getMessage(); 
    }
}
function cadastro_duracao_media_ciclo($opcao,$id){
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;
    $opcao = trim($opcao);
    if (empty($id) || empty($opcao)) {
        $msg = "Erro: nome ou id vazio.";
        return;
    }
    try {
        $query = $conn->prepare("UPDATE tb_informacoes SET ds_duracao_media_ciclo = :opcao WHERE cd_user = :cd LIMIT 1");
        $query->execute(array(
            ":opcao" => $opcao,
            ":cd" => $id
        ));
        $msg = "sucesso";
    } catch(\Throwable $th) {
       $msg = "Error: " . $th->getMessage(); 
    }
}
function cadastro_nivel_energia_ciclo($opcao,$id) {
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;
    $opcao = trim($opcao);
    if (empty($id) || empty($opcao)) {
        $msg = "Erro: nome ou id vazio.";
        return;
    }
    try {
        $query = $conn->prepare("UPDATE tb_informacoes SET ds_nivel_energia_ciclo = :opcao WHERE cd_user = :cd LIMIT 1");
        $query->execute(array(
            ":opcao" => $opcao,
            ":cd" => $id
        ));
        $msg = "sucesso";
    } catch(\Throwable $th) {
       $msg = "Error: " . $th->getMessage(); 
    }
}
function cadastro_humor_antes_mestruacao($opcao,$id) {
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;
    $opcao = trim($opcao);
    if (empty($id) || empty($opcao)) {
        $msg = "Erro: nome ou id vazio.";
        return;
    }
    try {
        $query = $conn->prepare("UPDATE tb_informacoes SET ds_humor_antes_mestruacao = :opcao WHERE cd_user = :cd LIMIT 1");
        $query->execute(array(
            ":opcao" => $opcao,
            ":cd" => $id
        ));
        $msg = "sucesso";
    } catch(\Throwable $th) {
       $msg = "Error: " . $th->getMessage(); 
    }
}
function cadastro_duracao_media_mestruacao($opcao,$id) {
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;
    $opcao = trim($opcao);
    if (empty($id) || empty($opcao)) {
        $msg = "Erro: nome ou id vazio.";
        return;
    }
    try {
        $query = $conn->prepare("UPDATE tb_informacoes SET ds_duracao_media_mestruacao = :opcao WHERE cd_user = :cd LIMIT 1");
        $query->execute(array(
            ":opcao" => $opcao,
            ":cd" => $id
        ));
        $msg = "sucesso";
    } catch(\Throwable $th) {
       $msg = "Error: " . $th->getMessage(); 
    }
}
function Pega_nome_email($id){
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;
    try {
        $query = $conn->prepare("SELECT * FROM tb_user WHERE cd_id = :cd LIMIT 1");
        $query->execute(array(
            ":cd" => $id
        ));
        $dado = $query->fetch(PDO::FETCH_ASSOC);
        $msg = $dado;
    } catch(\Throwable $th) {
       $msg = "Error: " . $th->getMessage(); 
    }
}
function Calendario_carregar_dados($id){
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;
    try {
        $query = $conn->prepare("SELECT dt_dias_mestruacao FROM tb_calendario WHERE cd_user = :cd");
        $query->execute(array(":cd" => $id));
        $dados = $query->fetchAll(PDO::FETCH_COLUMN);
        $msg = $dados; 
    } catch(\Throwable $th) {
       $msg = "Error: " . $th->getMessage(); 
    }
}
function Calendario_salvar_dia($data,$id){
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;
    $insert = $conn->prepare("INSERT IGNORE INTO tb_calendario (cd_user, dt_dias_mestruacao) VALUES (:cd, :dt)");
    $insert->execute(array(
        ":cd" => $id,
        ":dt" => $data
    ));
}
function Calendario_deletar_dia($data,$id){
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;
    $insert = $conn->prepare("DELETE FROM tb_calendario WHERE cd_user = :cd AND dt_dias_mestruacao = :dt LIMIT 1");
    $insert->execute(array(
        ":cd" => $id,
        ":dt" => $data
    ));
}
function data_atual(){
    global $msg;
    $msg = date("Y");
}
function Calendario_prever_dias($id) {
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;

    try {
        // Obter todas as datas do calendário ordenadas
        $stmt = $conn->prepare("SELECT dt_dias_mestruacao FROM tb_calendario WHERE cd_user = :cd ORDER BY dt_dias_mestruacao ASC");
        $stmt->execute([':cd' => $id]);
        $datas = $stmt->fetchAll(PDO::FETCH_COLUMN);
        if (count($datas) < 2) {
            $ultimaDataObj = count($datas) > 0 ? new DateTime($datas[0]) : null;
            $mediaCiclo = 28; // padrão
            if ($ultimaDataObj) {
                $proximaObj = clone $ultimaDataObj;
                $proximaObj->modify("+{$mediaCiclo} days");
                $hoje = new DateTime();
                $diasRestantes = (int)$hoje->diff($proximaObj)->format('%r%a');
            } else {
                $diasRestantes = null;
            }
            $msg = [
                'duracao_ciclo' => 28,
                'duracao_periodo' => 5,
                'dias_restantes' => $diasRestantes,
                'ultima_menstruacao' => count($datas) > 0 ? $datas[0] : null
            ];
            return;
        }
        // Calcular média de intervalo entre ciclos
        $somaIntervalos = 0;
        $quantidade = 0;
        for ($i = 1; $i < count($datas); $i++) {
            $data1 = new DateTime($datas[$i - 1]);
            $data2 = new DateTime($datas[$i]);
            $diff = $data2->diff($data1)->days;

            // Ignorar intervalos inválidos
            if ($diff >= 10 && $diff <= 60) {
                $somaIntervalos += $diff;
                $quantidade++;
            }
        }

        $mediaCiclo = $quantidade > 0 ? round($somaIntervalos / $quantidade) : 28;

        // Calcular média de duração da menstruação (dias consecutivos)
        $duracoes = [];
        $grupo = 1;
        for ($i = 1; $i < count($datas); $i++) {
            $dataAnterior = new DateTime($datas[$i - 1]);
            $dataAtual = new DateTime($datas[$i]);
            $diff = $dataAtual->diff($dataAnterior)->days;

            if ($diff == 1) {
                $grupo++;
            } else {
                $duracoes[] = $grupo;
                $grupo = 1;
            }
        }
        $duracoes[] = $grupo;
        $mediaPeriodo = count($duracoes) > 0 ? round(array_sum($duracoes) / count($duracoes)) : 5;

        // Pegar a última data e calcular próxima menstruação
        $ultimaDataObj = new DateTime(end($datas));
        $proximaObj = clone $ultimaDataObj;
        $proximaObj->modify("+{$mediaCiclo} days");

        $hoje = new DateTime();
        $diasRestantes = (int)$hoje->diff($proximaObj)->format('%r%a');

        // Resultado final
        $msg = [
            'duracao_ciclo' => $mediaCiclo,
            'duracao_periodo' => $mediaPeriodo,
            'dias_restantes' => $diasRestantes,
            'ultima_menstruacao' => $ultimaDataObj->format('Y-m-d')
        ];
    } catch (\Throwable $th) {
        $msg = ["erro" => $th->getMessage()];
    }
}
function Autocuidado_salvar($id, $data, $sintomas, $humores, $fluxo, $anotacao) {
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;

    // JSON encode nos campos múltiplos para armazenar como texto
    $sintomas = json_encode($sintomas);
    $humores = json_encode($humores);

    try {
        $query = $conn->prepare("SELECT COUNT(*) FROM tb_autocuidado WHERE cd_user = :cd AND dt_data = :dt");
        $query->execute(array(":cd" => $id, ":dt" => $data));
        $existe = $query->fetchColumn();

        if ($existe > 0) {
            $update = $conn->prepare("UPDATE tb_autocuidado SET ds_sintomas = :sintomas, ds_humores = :humor, ds_fluxo = :fluxo, ds_anotacao = :anotacao WHERE cd_user = :cd AND dt_data = :dt");
            $update->execute(array(
                ":sintomas" => $sintomas,
                ":humor" => $humores,
                ":fluxo" => $fluxo,
                ":anotacao" => $anotacao,
                ":cd" => $id,
                ":dt" => $data
            ));
        } else {
            $insert = $conn->prepare("INSERT INTO tb_autocuidado (cd_user, dt_data, ds_sintomas, ds_humores, ds_fluxo, ds_anotacao) VALUES (:cd, :dt, :sintomas, :humor, :fluxo, :anotacao)");
            $insert->execute(array(
                ":cd" => $id,
                ":dt" => $data,
                ":sintomas" => $sintomas,
                ":humor" => $humores, // ✅ Aqui também
                ":fluxo" => $fluxo,
                ":anotacao" => $anotacao
            ));
        }

        $msg = "sucesso";
    } catch (\Throwable $th) {
        $msg = "Erro: " . $th->getMessage();
    }
}
function Autocuidado_carregar($id) {
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;

    try {
        $query = $conn->prepare("SELECT dt_data, ds_sintomas, ds_humores, ds_fluxo, ds_anotacao FROM tb_autocuidado WHERE cd_user = :cd");
        $query->execute(array(":cd" => $id));
        $resultados = $query->fetchAll(PDO::FETCH_ASSOC);

        $dadosFormatados = [];

        foreach ($resultados as $row) {
            $data = $row['dt_data'];

            $dadosFormatados[$data] = [
                "humores" => json_decode($row['ds_humores'], true) ?: [],
                "sintomas" => json_decode($row['ds_sintomas'], true) ?: [],
                "fluxo" => $row['ds_fluxo'] ?? "",
                "anotacao" => $row['ds_anotacao'] ?? ""
            ];
        }

        $msg = $dadosFormatados;
    } catch (\Throwable $th) {
        $msg = ["erro" => $th->getMessage()];
    }
}
function dias_para_proxima_menstruacao($id) {
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;

    try {
        // 1. Buscar a última data de menstruação
        $stmt = $conn->prepare("SELECT MAX(dt_dias_mestruacao) as ultima_data FROM tb_calendario WHERE cd_user = :cd");
        $stmt->execute([':cd' => $id]);
        $ultimaData = $stmt->fetchColumn();

        // 2. Buscar a duração média do ciclo
        $stmt = $conn->prepare("SELECT ds_duracao_media_ciclo FROM tb_informacoes WHERE cd_user = :cd LIMIT 1");
        $stmt->execute([':cd' => $id]);
        $duracaoBruta = $stmt->fetchColumn();

        // Mapeia texto para número de dias
        $map = [
            "Menos de 21 dias" => 20,
            "Entre 21 e 35 dias" => 28,
            "Mais de 35 dias" => 40,
            "Não sei" => 28
        ];

        // Aplica mapeamento para obter valor numérico
        $duracaoCiclo = $map[$duracaoBruta] ?? (is_numeric($duracaoBruta) ? (int)$duracaoBruta : 28);

        $hoje = new DateTime();

        if (!$ultimaData) {
            // Se não tem última data, assume hoje como base
            $ultimaDataObj = clone $hoje;
        } else {
            $ultimaDataObj = new DateTime($ultimaData);
        }

        // Calcular diferença em dias entre última menstruação e hoje
        $diasDesdeUltima = (int)$ultimaDataObj->diff($hoje)->format('%a');

        // Calcular o dia do ciclo atual (modular)
        $diaDoCiclo = ($diasDesdeUltima % $duracaoCiclo) + 1; // +1 para começar em 1

        // Calcular próxima menstruação (data da última + ciclo)
        $proximaMenstruacao = clone $ultimaDataObj;
        $proximaMenstruacao->modify("+{$duracaoCiclo} days");

        // Calcular quantos dias faltam (pode ser negativo se atrasou)
        $diasRestantes = (int)$hoje->diff($proximaMenstruacao)->format('%r%a');

        // Status simples
        $status = $diasRestantes < 0 ? 'atrasada' : ($diasRestantes === 0 ? 'hoje' : 'aguardando');

        $msg = [
            "cd_user" => $id,
            "ultima_menstruacao" => $ultimaDataObj->format('Y-m-d'),
            "duracao_ciclo" => $duracaoCiclo, // Agora é apenas número
            "dias_estimados_ciclo" => $duracaoCiclo,
            "proxima_menstruacao" => $proximaMenstruacao->format('Y-m-d'),
            "dias_restantes" => $diasRestantes,
            "dia_do_ciclo" => $diaDoCiclo,
            "status" => $status
        ];

    } catch (\Throwable $th) {
        $msg = ["erro" => $th->getMessage()];
    }
}
function estatisticas_caregamento($id)  {
    require_once 'conecta.php';
    $conn = getConnection();
    global $msg;

    try {
        $hoje = new DateTime();

        // 1. Buscar todas as datas de menstruação
        $stmt = $conn->prepare("SELECT dt_dias_mestruacao FROM tb_calendario WHERE cd_user = :cd ORDER BY dt_dias_mestruacao ASC");
        $stmt->execute([':cd' => $id]);
        $datas = $stmt->fetchAll(PDO::FETCH_COLUMN);

        // Calcular variação de ciclo
        $ciclos = [];
        for ($i = 1; $i < count($datas); $i++) {
            $dataAnterior = new DateTime($datas[$i - 1]);
            $dataAtual = new DateTime($datas[$i]);
            $dias = $dataAnterior->diff($dataAtual)->days;
            $ciclos[] = $dias;
        }

        $variacao = 0;
        if (count($ciclos) > 1) {
            $variacao = max($ciclos) - min($ciclos);
        }

        $ultimaData = end($datas);
        $ultimaDataObj = $ultimaData ? new DateTime($ultimaData) : clone $hoje;

        // 2. Buscar informações do ciclo (duracao ciclo e periodo)
        $stmt = $conn->prepare("SELECT ds_duracao_media_ciclo, ds_duracao_media_mestruacao FROM tb_informacoes WHERE cd_user = :cd LIMIT 1");
        $stmt->execute([':cd' => $id]);
        $dados = $stmt->fetch(PDO::FETCH_ASSOC);

        // Mapeia texto para número
        $mapCiclo = [
            "Menos de 21 dias" => 20,
            "Entre 21 e 35 dias" => 28,
            "Mais de 35 dias" => 40,
            "Não sei" => 28
        ];
        $mapPeriodo = [
            "Menos de 3 dias" => 2,
            "Entre 3 e 7 dias" => 5,
            "Mais de 7 dias" => 8,
            "Não sei" => 5
        ];

        $duracaoCiclo = $mapCiclo[$dados['ds_duracao_media_ciclo']] ?? (is_numeric($dados['ds_duracao_media_ciclo']) ? (int)$dados['ds_duracao_media_ciclo'] : 28);
        $duracaoPeriodo = $mapPeriodo[$dados['ds_duracao_media_mestruacao']] ?? (is_numeric($dados['ds_duracao_media_mestruacao']) ? (int)$dados['ds_duracao_media_mestruacao'] : 5);

        // 3. Cálculo da próxima menstruação
        $diasDesdeUltima = (int)$ultimaDataObj->diff($hoje)->format('%a');
        $diaDoCiclo = ($diasDesdeUltima % $duracaoCiclo) + 1;

        $proximaMenstruacao = clone $ultimaDataObj;
        $proximaMenstruacao->modify("+{$duracaoCiclo} days");
        $diasRestantes = (int)$hoje->diff($proximaMenstruacao)->format('%r%a');

        // 4. Retorno formatado para Flutter
        $msg = [
            "folicular" => max(0, $diasRestantes),
            "duracao_periodo" => $duracaoPeriodo,
            "duracao_ciclo" => $duracaoCiclo,
            "variacao_ciclo" => $variacao
        ];

    } catch (\Throwable $th) {
        $msg = ["erro" => $th->getMessage()];
    }
}
echo json_encode([
    "data" => [
        $msg
    ]
]);