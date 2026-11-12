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
function valida_email_multi($email) {
    $email = trim($email);
    if (filter_var($email, FILTER_VALIDATE_EMAIL) !== false) {
        return true;
    }
    if (preg_match("/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/", $email)) {
        return true;
    }
    if (strpos($email, '@') !== false && strpos($email, '.') !== false) {
        return true;
    }
    return false;
}
$dados = array("email" => $_POST['email'], "senha" => $_POST['senha']);
$dados = array_map("trim", $dados);
try{
    if(isset($dados['email']) && isset($dados['senha']) && !empty($dados['email']) && !empty($dados['senha'])){
        if(valida_email_multi($dados['email'])){
            $veri = $conn->prepare('SELECT * FROM tb_user WHERE nm_email = :email');
            $veri->bindParam(':email', $dados['email'], PDO::PARAM_STR);
            $veri->execute();
            $smtd = $veri->fetch(PDO::FETCH_ASSOC);
            if($smtd AND $veri->rowCount() != 0){
                $msg = "Erro no cadastro, esse email já está em uso por outra conta.";
            } else {
                $dados['senha'] = password_hash($dados['senha'],PASSWORD_DEFAULT);
                $cadastro = $conn->prepare('INSERT INTO tb_user VALUES(null,null,:email,:senha)');
                $cadastro->execute(array(
                    ":email" => $dados['email'],
                    ":senha" => $dados['senha']
                ));
                if($cadastro){
                    $idUsuario = strval($conn->lastInsertId());
                    $msg = "Cadastro realizado com sucesso.";
                } else {
                    $msg = "Error ao realizar o cadastro.";
                }
            }
        } else {
            $msg = "Escreva um email valido.";
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
        $idUsuario
    ]
]);