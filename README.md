# My Products Challenge

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
* **Frontend (Flutter + GetX)**: App que consome a API e exibe produtos em uma grade de cartões, com busca por nome, paginação infinita e tratamento de estados (loading, erro, vazio).

## 3. Funcionalidades

### Backend (.NET 8)

* **GET** `/api/products?page={p}&pageSize={n}`

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

* **Consumo HTTP**: `http.get` com header de autenticação carregado de `.env` (via `flutter_dotenv`).
* **Grid de Produtos**: `GridView.builder` com `Card` mostrando imagem, nome (negrito) e preço (`R$ 0,00`).
* **Filtro por Nome**: `TextField` atualiza `searchQuery`, filtrando a lista localmente.
* **Paginação Infinita**: scroll detecta fim da lista e carrega próxima página (`loadMore()`).
* **Tratamento de Estados**: loading, error (mensagem), vazio ("Nenhum produto encontrado") e fallback de imagem (ícone).

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
    │   ├── data/         # Modelos e serviços de API
    │   └── modules/      # Feature "products": bindings, controllers, views
    ├── assets/           # (opcional) arquivos estáticos
    └── test/             # Testes unitários e de widget (opcional)
```

## 5. Pré-requisitos

* **Git**
* **.NET 8 SDK** (versão 8.0.411)
* **Flutter SDK** (canal stable)
* **curl** ou **Postman** para testes

## 6. Executando Localmente

### 6.1 Backend

```bash
cd ProductApi
dotnet restore
dotnet run
# API disponível em http://localhost:<porta>
```

### 6.2 Frontend

```bash
cd product_app
cp .env.example .env
# Edite .env para ajustar API_URL e API_KEY
flutter pub get
flutter run
```

## 7. Testes e Documentação

* **Swagger UI**: `http://localhost:<porta>/swagger/index.html`
* **Teste API via curl**:

  ```bash
  curl -i \
    -H "X-Api-Key: MINHA_CHAVE_SECRETA" \
    "http://localhost:<porta>/api/products?page=1&pageSize=5"
  ```
