# My Products

**Autor:** Danilo de Melo Arraes Pessoa (DaniloMAP)

Repositório: [https://github.com/DaniloMAP/My\_Products](https://github.com/DaniloMAP/My_Products)

## 1. Clonando o Repositório

```bash
git clone https://github.com/DaniloMAP/My_Products.git
cd My_Products
```

## 2. Descrição do Desafio

Desenvolver um *Sistema de Visualização de Produtos* composto por:

* **Backend (.NET 8)**: API REST que retorna uma lista de produtos (ID, nome, preço e foto), autenticada via API Key.
* **Frontend (Flutter + GetX)**: App que consome a API e exibe produtos em uma grade de cartões, com busca por nome, paginação infinita e tratamento de estados (loading, erro, vazio), seguindo arquitetura em camadas com separação de responsabilidades.

## 3. Funcionalidades

### Backend (.NET 8)

* **GET** `/api/products?page={p}&pageSize={n}&search={query}`

  * Retorna *200 OK* com envelope JSON:

    ```json
    {
      "page": 1,
      "pageSize": 10,
      "totalCount": 50,
      "items": [ { ... } ]
    }
    ```
* **API Key**: cabeçalho `X-Api-Key: MINHA_CHAVE_SECRETA`; chave inválida gera *401 Unauthorized*.
* **Dados em memória**: simulação de banco com `Enumerable.Range` e `picsum.photos` para imagens.
* **Swagger**: documentação interativa em `/swagger/index.html`.

### Frontend (Flutter + GetX)

* **Arquitetura em Camadas**: Clean Architecture com separação de responsabilidades (Network, Repository, Service, Controller).
* **Network Layer**: `ApiClient` centralizado para configuração HTTP e reutilização de código.
* **Repository Pattern**: Abstração da fonte de dados com interfaces bem definidas.
* **Services Layer**: Encapsulamento das regras de negócio relacionadas a produtos.
* **Dependency Injection**: Gerenciamento de dependências com GetX Bindings.
* **Grid de Produtos**: `GridView.builder` com `Card` mostrando imagem, nome (negrito) e preço (`R$ 0,00`).
* **Busca Inteligente**: `TextField` com debounce que realiza busca na API com tratamento de estados específicos.
* **Paginação Infinita**: scroll detecta fim da lista e carrega próxima página automaticamente.
* **Tratamento de Estados**: loading, error (mensagem personalizada), vazio ("Nenhum produto encontrado"), busca vazia e fallback de imagem.
* **Tratamento de Erros Centralizado**: Exceptions customizadas com mensagens amigáveis ao usuário.

## 4. Estrutura de Pastas

```
My_Products/
├── ProductApi/           # Backend .NET 8
│   ├── Program.cs        # Endpoints, middleware de API Key e paginação
│   ├── Models/           # Classe Product em memória
│   └── Properties/       # launchSettings.json
└── product_app/          # App Flutter + GetX
    ├── .env.example      # Exemplo de variáveis (não versionar .env)
    ├── pubspec.yaml      # Dependências do Flutter
    ├── lib/
    │   ├── main.dart     # Carrega .env e inicializa App
    │   ├── app.dart      # Rotas e bindings GetX
    │   ├── core/         # Configurações centrais e utilitários
    │   │   ├── constants/    # Constantes da aplicação
    │   │   ├── exceptions/   # Exceções customizadas
    │   │   └── network/      # Cliente HTTP centralizado
    │   ├── data/         # Camada de dados
    │   │   ├── datasources/  # Fontes de dados (API)
    │   │   ├── models/       # Modelos de dados
    │   │   └── repositories/ # Implementação dos repositórios
    │   ├── domain/       # Camada de domínio
    │   │   └── services/     # Serviços com regras de negócio
    │   └── modules/      # Features organizadas por módulos
    │       └── products/     # Módulo de produtos
    │           ├── bindings/     # Injeção de dependências
    │           ├── controllers/  # Controladores GetX
    │           └── views/        # Páginas e widgets
    │               ├── pages/        # Páginas principais
    │               └── widgets/      # Widgets reutilizáveis
    ├── assets/           # (opcional) arquivos estáticos
    └── test/             # Testes unitários e de widget (opcional)
```

## 5. Arquitetura e Padrões Utilizados

### Camadas da Aplicação

* **Network Layer**: Centraliza configuração HTTP, headers, timeouts e tratamento de erros.
* **Data Layer**: Gerencia acesso aos dados através de datasources e repositories.
* **Domain Layer**: Contém regras de negócio e serviços da aplicação.
* **Presentation Layer**: Controllers, páginas e widgets para interface do usuário.

### Padrões Implementados

* **Repository Pattern**: Abstração da fonte de dados
* **Dependency Injection**: Gerenciamento automático de dependências
* **Clean Architecture**: Separação clara de responsabilidades
* **Exception Handling**: Tratamento centralizado de erros
* **Debounce**: Otimização de requisições de busca

## 6. Pré-requisitos

* **Git**
* **.NET 8 SDK** (versão 8.0.411)
* **Flutter SDK** (canal stable)
* **curl** ou **Postman** para testes

## 7. Executando Localmente

### 7.1 Backend

```bash
cd ProductApi
dotnet restore
dotnet run
# API disponível em http://localhost:<porta>
```

### 7.2 Frontend

```bash
cd product_app
cp .env.example .env
# Edite .env para ajustar API_URL e API_KEY
flutter pub get
flutter run
```

## 8. Testes e Documentação

* **Swagger UI**: `http://localhost:<porta>/swagger/index.html`
* **Teste API via curl**:

  ```bash
  curl -i \
    -H "X-Api-Key: MINHA_CHAVE_SECRETA" \
    "http://localhost:<porta>/api/products?page=1&pageSize=5"
  ```

* **Teste busca via curl**:

  ```bash
  curl -i \
    -H "X-Api-Key: MINHA_CHAVE_SECRETA" \
    "http://localhost:<porta>/api/products?page=1&pageSize=5&search=produto"
  ```

## 9. Melhorias Implementadas

* **Arquitetura Escalável**: Estrutura preparada para crescimento do projeto
* **Código Limpo**: Cada classe tem responsabilidade única e bem definida
* **Reutilização**: Componentes modulares e reutilizáveis
* **Manutenibilidade**: Fácil de manter e evoluir
* **Testabilidade**: Estrutura preparada para testes unitários
* **Performance**: Otimizações em requisições e renderização
