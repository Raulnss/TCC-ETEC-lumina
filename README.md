 Lúmina 

<p align="center">
Aplicativo de monitoramento menstrual.
</p>

✨ Sobre o projeto

O Lúmina é um aplicativo desenvolvido com o objetivo de auxiliar mulheres e jovens no acompanhamento do ciclo menstrual, promovendo o autoconhecimento, o autocuidado e o acesso à informação sobre saúde feminina.

O projeto surgiu a partir da identificação da falta de informações acessíveis e confiáveis sobre menstruação, higiene íntima e educação sexual, especialmente entre jovens.

Mais do que um aplicativo de monitoramento menstrual, o Lúmina busca ser um espaço de aprendizado e acolhimento, permitindo que suas usuárias compreendam melhor seu corpo e acompanhem as diferentes fases do ciclo.

🌷 Lúmina — Brilhe em cada passo, cuide-se em cada fase.
🎯 Objetivos
Facilitar o acompanhamento e o controle do ciclo menstrual.
Permitir o registro de sintomas físicos e emocionais.
Disponibilizar previsões das próximas menstruações.
Apresentar estatísticas e informações sobre o ciclo.
Promover o conhecimento sobre saúde íntima e educação menstrual.
Incentivar o autocuidado e a autonomia das usuárias.
🚀 Funcionalidades

O aplicativo foi planejado com diversas funcionalidades para proporcionar uma experiência intuitiva e completa.

Funcionalidade	Descrição
🔐 Cadastro e Login	Criação de conta e autenticação de usuárias.
📅 Calendário menstrual	Registro e acompanhamento dos dias de menstruação.
⏳ Previsão do ciclo	Estimativa da próxima menstruação e das fases do ciclo.
💗 Registro de sintomas	Cadastro de sintomas físicos, emocionais, humor e fluxo menstrual.
📊 Estatísticas	Visualização de informações e médias relacionadas ao ciclo.
👤 Perfil	Gerenciamento das informações pessoais da usuária.
🔔 Notificações	Configuração dos avisos do aplicativo.
🎨 Tema personalizado	Alternância entre modo claro e modo escuro.
🔑 Alteração de senha	Possibilidade de atualizar a senha da conta.
📚 Área educativa	Conteúdos informativos sobre ciclo menstrual e saúde íntima.
🛠️ Tecnologias utilizadas

O desenvolvimento do Lúmina utiliza tecnologias voltadas à construção de aplicações mobile e gerenciamento de dados.

Tecnologia	Utilização
Flutter	Desenvolvimento da interface mobile.
PHP	Desenvolvimento do Back-end e comunicação com o banco de dados.
MySQL	Armazenamento e gerenciamento das informações.
Apache	Servidor responsável pela execução da aplicação Back-end.
Dart	Linguagem utilizada no desenvolvimento Flutter.



O Lúmina foi projetado para oferecer uma navegação simples e intuitiva, com telas organizadas para facilitar o acesso às funcionalidades.

Entre as principais telas estão:

Tela de carregamento;
Telas de apresentação (Onboarding);
Login e cadastro;
Cadastro inicial de informações;
Tela inicial (Home);
Calendário menstrual;
Registro de sintomas e autocuidado;
Estatísticas do ciclo;
Perfil da usuária;
Alteração de senha;
Notificações.
Prévia do aplicativo: adicione imagens das telas na pasta assets/screenshots e utilize a seção abaixo para apresentá-las.

<!-- Exemplo para adicionar imagens:
<p align="center">
<img src="assets/screenshots/home.png" width="200">
<img src="assets/screenshots/calendario.png" width="200">
<img src="assets/screenshots/estatisticas.png" width="200">
</p>
-->

🏗️ Arquitetura do projeto

O projeto utiliza uma arquitetura baseada na comunicação entre o aplicativo mobile, o Back-end e o banco de dados.

text
┌──────────────────────────┐
│       Aplicativo         │
│         Flutter          │
│                          │
│   Interface e navegação  │
└────────────┬─────────────┘
             │
             │ Requisições HTTP
             ▼
┌──────────────────────────┐
│         Back-end         │
│           PHP            │
│                          │
│ Regras de negócio e API  │
└────────────┬─────────────┘
             │
             │ Consultas SQL
             ▼
┌──────────────────────────┐
│        Banco de Dados    │
│           MySQL          │
│                          │
│ Dados das usuárias       │
└──────────────────────────┘

⚙️ Como executar o projeto
Pré-requisitos

Antes de executar o projeto, é necessário possuir:

Flutter SDK
Dart SDK
PHP
MySQL
Apache
Um editor de código, como Visual Studio Code.
1. Clone o repositório
bash
git clone https://github.com/SEU-USUARIO/SEU-REPOSITORIO.git

2. Entre na pasta do projeto
bash
cd SEU-REPOSITORIO

3. Instale as dependências do Flutter
bash
flutter pub get

4. Configure o Back-end
Configure o servidor Apache.
Disponibilize os arquivos PHP no diretório do servidor.
Configure a conexão com o banco de dados MySQL.
Importe o arquivo SQL do projeto, caso esteja disponível.
Configure corretamente o endereço da API utilizado pelo aplicativo.
5. Execute o aplicativo

Verifique os dispositivos disponíveis:

bash
flutter devices


Execute o projeto:

bash
flutter run


Observação: os comandos e configurações podem variar conforme a estrutura atual do repositório e o ambiente de desenvolvimento.

🔒 Segurança e privacidade

O Lúmina trabalha com informações pessoais e registros relacionados ao ciclo menstrual. Por isso, a segurança e a privacidade devem ser consideradas durante o desenvolvimento.

Entre os requisitos definidos para o projeto estão:

Proteção das informações das usuárias.
Armazenamento seguro de credenciais.
Criptografia ou hash adequado de senhas.
Controle de autenticação.
Proteção da comunicação entre aplicativo e servidor.

Importante: as previsões menstruais são estimativas e não substituem avaliações ou orientações de profissionais de saúde.


Curso Técnico em Desenvolvimento de Sistemas.

Projeto acadêmico desenvolvido em 2025.

📚 Referências
ONU Brasil — Pobreza menstrual e educação
G1 — Saúde menstrual e evasão escolar
Vídeo educativo sobre o ciclo menstrual
 Considerações finais

O Lúmina nasceu com um propósito: tornar o conhecimento sobre o ciclo menstrual mais acessível, incentivar o autocuidado e ajudar mulheres e jovens a desenvolverem uma relação mais consciente com o próprio corpo.

Acreditamos que informação também é uma forma de cuidado.

<p align="center">
<br>
<strong>Lúmina © 2025</strong>
<br>
ETEC de Itanhaém — Centro Paula Souza
</p>
