<?php
header("Access-Control-Allow-Origin: *"); // ou coloque "http://localhost:port" se quiser restringir
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");

// Responde requisições OPTIONS automaticamente (pré-flight)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit();
}
include 'conecta.php';
$conn = getConnection();
$dados = array("email" => $_POST['email'], "senha" => $_POST['senha']);
$dados = array_map("trim", $dados);
$sucess = 0;
try{
    if(isset($dados['email']) && isset($dados['senha']) && !empty($dados['email']) && !empty($dados['senha'])){
        $veri = $conn->prepare('SELECT * FROM tb_user WHERE nm_email = :email LIMIT 1');
        $veri->bindParam(':email', $dados['email'], PDO::PARAM_STR);
        $veri->execute();
        $smtd = $veri->fetch(PDO::FETCH_ASSOC);
        if($smtd && $veri->rowCount() != 0 && password_verify($dados['senha'],$smtd['cd_senha'])){
            $msg = "logado";
            $sucess = 1;
        } else {
            $msg = "Usuario ou senha incorretos.";
        }
    } else {
        $msg = "Nenhum valor foi encontrado.";
    }
} catch(\Throwable $th) {
    $msg = "Error: " . $th->getMessage(); 
}
echo json_encode([
    "data" => [
        $msg,
        $smtd,
        $sucess
    ]
]);