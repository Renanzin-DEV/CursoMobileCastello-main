# CineFavorite - Formativa
Construir um Aplicativo do Zero - O CineFavorite permitirá criar uma conta e buscar filmes em uma API e montar uma galeria pessoa de filmes favoritos, com posters e notas.

## Objetivos
- Criar uma galeria personalizada por usuário de filmes favoritos;
- Fazer conexão com uma API (base de dados) de filmes;
- Permitir a criação de contas para cada usuário;
- Listagem de filmes por palavra-chave.

## Levantamento de Requisitos do Projeto
    ### - Funcionais
    ### - Não Funcionais

## Recursos do Projeto
- Flutter / Dart
- Firebase ( Authentication / FireStore Database )
- API TMDB
- Figma
- VsCode

## Diagramas
    ### 1. Classes
    Demonstrar o funcionamento das entidades (informação armazenada no banco de dados) do sistema
    - User :  classe já modelada pelo FirebaseAuth
        - email
        - senha
        - uid

        - login()
        - logout()
        - create()

    - Favorito :  classe modelada pelo desenvolvedor
        - number: id
        - string: titulo
        - string: poster
        - double: rating

        - adicionar()
        - remover()
        - listar()
        - atualizar()

```mermaid

    classDiagram
        class User{
            +String uid
            +String email
            +String password
            +createUser()
            +login()
            +logout()
        }

        class Favorite{
            +Sring id
            +Sring title
            +Sring posterPath
            +double rating
            
            +addFavorite()
            +removeFavorite()
            +updateFavorite()
            +readList()
        }

        User "1" --> "*" Favorite : log

```

    ### 2. Uso
    Ações dos atores:
    - User:
        - Registrar
        - Login
        - Logout
        - Procurar
        - Salvar filmes
        - Dar nota aos filmes
        - Remover dos favoritos

```mermaid

graph TD
    User((User))

    subgraph actions
        uc1[Registrar]
        uc2[Login]
        uc3[Logout]
        uc4[Procurar]
        uc5[Favoritar filme]
        uc6[Dar nota ao filme]
        uc7[Remover dos favoritos]
    end

    User --> uc1
    User --> uc2 
    User --> uc3 
    User --> uc4 
    User --> uc5 
    User --> uc6 
    User --> uc7 

    uc1 --> uc2
    uc2 --> uc3
    uc2 --> uc4
    uc2 --> uc5
    uc2 --> uc6
    uc2 --> uc7

```

    ### 3. Fluxo
    Determina o caminho percorrido pelo ator para executar uma ação.
    - Ação de Login

```mermaid

flowchart TD
    A[Início] --> B[Usuário insere login e senha]
    B --> C{Credenciais corretas?}
    C -- Sim --> D[Login bem-sucedido]
    C -- Não --> F[Exibir mensagem de erro]
    F --> B
    D --> E[Tela de Favoritos]

```

## Prototipagem
Figma - https://www.figma.com/design/FrWsF1g1JfdSFVsF7KEOKB/CineFavorito?node-id=0-1&t=5xIAS5svrHcpaZcg-1

## Codificação