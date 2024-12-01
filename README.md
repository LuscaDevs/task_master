# Task Master - Gerenciador de Tarefas

## Descrição

O **Task Master** é um aplicativo de gerenciamento de tarefas desenvolvido em **Flutter**. Ele permite ao usuário criar, editar, excluir e organizar tarefas com prazos, categorias e status. O aplicativo utiliza o **SQLite** para armazenar dados localmente e o **Firebase** para autenticação de usuários.

## Integrante do grupo

**Lucas dos Santos Silva** - RA 1282314493

## Links

[Download APK](https://drive.google.com/file/d/1GFembW8tTg6_SdHLvxJ4w6RC0KxY2DMQ/view?usp=sharing)

[PDF de apresentação](https://drive.google.com/file/d/1odDFu1RZe03cq4BNZo0Luhobuo0nmB6d/view?usp=sharing)

[Vídeo explicativo](https://drive.google.com/file/d/1LaM7fWjam6fWwNBtm-Of5sA2V-WSRT8V/view?usp=sharing)

## Funcionalidades

- **Autenticação**: Permite login e cadastro de usuários através do Firebase.
- **Gerenciamento de Tarefas**:
  - Criar novas tarefas com título, descrição, categoria e data de vencimento.
  - Editar ou excluir tarefas existentes.
  - Marcar tarefas como completas ou pendentes.
  - Filtro de tarefas por categoria.
  - Pesquisa de tarefas por título ou descrição.
- **Tema Claro/Oscuro**: Alternância entre temas claro e escuro para uma experiência personalizada.
- **Tela de Perfil de Usuário**: Exibição e edição do perfil do usuário.

## Tecnologias Usadas

- **Flutter**: Framework para desenvolvimento de aplicativos móveis.
- **SQLite**: Banco de dados local para armazenamento de tarefas.
- **Firebase Authentication**: Autenticação de usuários.
- **Provider**: Gerenciamento de estado.
- **Dart**: Linguagem utilizada para o desenvolvimento do aplicativo.

## Como Rodar o Projeto

### Pré-requisitos

Certifique-se de ter o **Flutter** instalado no seu computador. Caso ainda não tenha o Flutter, siga as instruções oficiais de instalação:

[Instalação do Flutter](https://flutter.dev/docs/get-started/install)

Além disso, você precisará configurar o **Firebase** para autenticação. Para isso, siga a documentação oficial:

[Firebase para Flutter](https://firebase.flutter.dev/docs/overview)

### Passos

1. Clone o repositório:

    ```bash
    git clone https://github.com/seu-usuario/task-master.git
    ```

2. Navegue até o diretório do projeto:

    ```bash
    cd task-master
    ```

3. Instale as dependências:

    ```bash
    flutter pub get
    ```

4. Configure o Firebase:
    - Crie um novo projeto no [Firebase Console](https://console.firebase.google.com/).
    - Adicione o aplicativo no Firebase e siga as instruções para configuração do Firebase Authentication.
    - Baixe o arquivo `google-services.json` (Android) ou `GoogleService-Info.plist` (iOS) e adicione-os aos diretórios apropriados do seu projeto.

5. Execute o aplicativo:

    ```bash
    flutter run
    ```

## Estrutura do Projeto

- **lib/**: Contém o código-fonte do aplicativo.
  - **models/**: Contém modelos de dados, como o modelo de `Task`.
  - **screens/**: Contém as telas do aplicativo, como `TaskListScreen`, `AddEditTaskScreen`, `SettingsScreen`.
  - **services/**: Contém a lógica de acesso ao banco de dados e integração com Firebase.
  - **utils/**: Contém utilitários e configurações globais, como temas e constantes.

## Contribuição

Sinta-se à vontade para contribuir com o projeto! Se você encontrar algum erro ou tiver uma sugestão, abra uma **issue** ou faça um **pull request**.

## Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para mais detalhes.
