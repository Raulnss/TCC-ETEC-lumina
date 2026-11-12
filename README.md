
# Lúmina — Aplicativo de Monitoramento de Atividade Menstrual

Aplicativo desenvolvido para auxiliar no monitoramento do ciclo menstrual, registro de sintomas e disseminação de informações educativas sobre saúde menstrual e cuidados íntimos.

---

## Sobre o projeto

O **Lúmina** é um aplicativo desenvolvido com o objetivo de facilitar o acompanhamento do ciclo menstrual e promover o acesso a informações confiáveis sobre saúde feminina.

O projeto surgiu a partir da identificação da falta de conhecimento e de acesso a conteúdos educativos sobre menstruação, higiene íntima e educação sexual, especialmente entre o público jovem.

A proposta é oferecer uma plataforma intuitiva que permita às usuárias registrar informações sobre seus ciclos, acompanhar sintomas, visualizar previsões e consultar conteúdos educativos relacionados à saúde menstrual.

Mais do que uma ferramenta de monitoramento, o Lúmina busca incentivar o autoconhecimento, a autonomia e o cuidado com a saúde.

## Objetivos

- Facilitar o acompanhamento do ciclo menstrual.
- Permitir o registro de sintomas físicos e emocionais.
- Disponibilizar previsões das próximas menstruações.
- Apresentar estatísticas e informações sobre o ciclo.
- Promover o acesso a conteúdos educativos sobre saúde íntima.
- Incentivar o autocuidado e o autoconhecimento.

## Funcionalidades

O aplicativo conta com funcionalidades destinadas ao acompanhamento e gerenciamento das informações menstruais.

| Funcionalidade | Descrição |
|---|---|
| Cadastro e Login | Criação de conta e autenticação de usuárias. |
| Calendário menstrual | Registro e acompanhamento dos dias de menstruação. |
| Previsão do ciclo | Estimativa da próxima menstruação e das fases do ciclo. |
| Registro de sintomas | Cadastro de sintomas físicos, emocionais, humor e fluxo menstrual. |
| Estatísticas | Visualização de informações e médias relacionadas ao ciclo. |
| Perfil | Gerenciamento das informações pessoais da usuária. |
| Notificações | Configuração dos avisos do aplicativo. |
| Tema personalizado | Alternância entre modo claro e modo escuro. |
| Alteração de senha | Possibilidade de atualizar a senha da conta. |
| Área educativa | Conteúdos informativos sobre ciclo menstrual e saúde íntima. |

## Tecnologias utilizadas

O desenvolvimento do Lúmina utiliza tecnologias voltadas à criação de aplicações mobile, desenvolvimento Back-end e gerenciamento de dados.

| Tecnologia | Utilização |
|---|---|
| Flutter | Desenvolvimento da aplicação mobile. |
| Dart | Linguagem de programação utilizada no Flutter. |
| PHP | Desenvolvimento do Back-end e comunicação com o banco de dados. |
| MySQL | Armazenamento e gerenciamento das informações. |
| Apache | Servidor responsável pela execução do Back-end. |

## Arquitetura do projeto

O projeto utiliza uma arquitetura baseada na comunicação entre o aplicativo mobile, o Back-end e o banco de dados.

```text
+----------------------------+
|       Aplicativo           |
|         Flutter            |
|                            |
| Interface e navegação      |
+-------------+--------------+
              |
              | Requisições HTTP
              |
              v
+----------------------------+
|         Back-end           |
|           PHP              |
|                            |
| Regras de negócio e API    |
+-------------+--------------+
              |
              | Consultas SQL
              |
              v
+----------------------------+
|       Banco de Dados       |
|           MySQL            |
|                            |
| Armazenamento de dados     |
+----------------------------+
```

## Como executar o projeto

### Pré-requisitos

Antes de executar o projeto, é necessário possuir as seguintes ferramentas instaladas:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [PHP](https://www.php.net/)
- [MySQL](https://www.mysql.com/)
- [Apache](https://httpd.apache.org/)
- Editor de código, como [Visual Studio Code](https://code.visualstudio.com/).

### 1. Clonar o repositório

```bash
git clone https://github.com/SEU-USUARIO/SEU-REPOSITORIO.git
```

### 2. Acessar a pasta do projeto

```bash
cd SEU-REPOSITORIO
```

### 3. Instalar as dependências

Execute o comando abaixo na pasta do projeto Flutter:

```bash
flutter pub get
```

### 4. Configurar o Back-end

- Configure o servidor Apache.
- Disponibilize os arquivos PHP no diretório do servidor.
- Configure a conexão com o banco de dados MySQL.
- Importe o arquivo SQL do projeto, caso esteja disponível.
- Configure o endereço da API utilizado pelo aplicativo.

### 5. Executar o aplicativo

Verifique os dispositivos disponíveis:

```bash
flutter devices
```

Execute o projeto:

```bash
flutter run
```

**Observação:** os comandos e configurações podem variar conforme a estrutura atual do projeto e o ambiente de desenvolvimento.

## Telas do aplicativo

O Lúmina possui uma interface organizada para facilitar a navegação e o acesso às funcionalidades.

Entre as principais telas estão:

- Tela de carregamento;
- Telas de introdução (Onboarding);
- Login e cadastro;
- Cadastro inicial de informações;
- Tela inicial (Home);
- Calendário menstrual;
- Registro de sintomas e autocuidado;
- Estatísticas do ciclo;
- Perfil da usuária;
- Alteração de senha;
- Configurações de notificações.

### Capturas de tela

As imagens das principais telas podem ser adicionadas nesta seção.

Sugestão de organização:

```text
assets/
└── screenshots/
    ├── home.png
    ├── login.png
    ├── cadastro.png
    ├── calendario.png
    ├── autocuidado.png
    ├── estatisticas.png
    └── perfil.png
```

Exemplo de exibição:

```html
<p align="center">
  <img src="assets/screenshots/home.png" width="200">
  <img src="assets/screenshots/calendario.png" width="200">
  <img src="assets/screenshots/estatisticas.png" width="200">
</p>
```

## Segurança e privacidade

Considerando que o aplicativo trabalha com informações pessoais e registros relacionados ao ciclo menstrual, a segurança e a privacidade dos dados são aspectos importantes do projeto.

Entre os requisitos de segurança definidos estão:

- Proteção das informações das usuárias.
- Armazenamento seguro de credenciais.
- Proteção das senhas por meio de hash criptográfico adequado.
- Controle de autenticação.
- Proteção da comunicação entre aplicativo e servidor.

**Importante:** as previsões do ciclo menstrual são estimativas e não substituem avaliações ou orientações de profissionais de saúde.

### Orientadores

- Augusto Fabiano Abranches
- Osvaldo Luiz P. Bertoli

## Instituição de ensino

**Centro Paula Souza — ETEC de Itanhaém**

Curso Técnico em Desenvolvimento de Sistemas.

Projeto acadêmico desenvolvido em 2025.

## Referências

- [ONU Brasil — Pobreza menstrual e educação](https://brasil.un.org/pt-br/136226-62-das-jovens-que-menstruam-j%C3%A1-deixaram-de-ir%C3%A0-escola-ou-outro-lugar-por-causa-da)
- [G1 — Saúde menstrual e evasão escolar](https://g1.globo.com/sp/santos-regiao/educacao/noticia/2024/11/04/pesquisa-identifica-saude-menstrual-como-causa-de-evasao-escolar-em-cidade-no-litoral-de-sp-entenda.ghtml)
- [Vídeo educativo sobre o ciclo menstrual](https://www.youtube.com/watch?v=ujqPbVc9zE0)


ETEC de Itanhaém | 2025.
