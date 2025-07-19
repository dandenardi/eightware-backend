# Auth Backend - Rails API com JWT

Backend Rails para aplicação de autenticação com JWT usando Devise.

## 🚀 Tecnologias

- Ruby 3.2.0
- Rails 7.2
- PostgreSQL
- Devise + devise-jwt
- RSpec (TDD)
- JWT Authentication

## 📋 Pré-requisitos

- Ruby 3.2.0
- PostgreSQL
- Bundler

## 🔧 Instalação

### 1. Clone o repositório

```bash
git clone <your-repo-url>
cd auth_backend
```

### 2. Instale as dependências

```bash
bundle install
```

### 3. Configure as variáveis de ambiente

```bash
cp .env.example .env
```

Edite o arquivo `.env` com suas configurações:

```env
DB_USERNAME=postgres
DB_PASSWORD=password
DB_HOST=localhost
FRONTEND_URL=http://localhost:3000
JWT_SECRET_KEY=your-super-secret-jwt-key-here
DEVISE_JWT_SECRET_KEY=your-devise-jwt-secret-key-here
```

### 4. Configure o banco de dados

```bash
# Criar banco de dados
rails db:create

# Rodar migrações
rails db:migrate

# (Opcional) Rodar seeds
rails db:seed
```

### 5. Iniciar o servidor

```bash
rails server
```

O servidor estará disponível em `http://localhost:3000`

## 🧪 Testes

### Rodar todos os testes

```bash
bundle exec rspec
```

### Rodar testes específicos

```bash
# Modelos
bundle exec rspec spec/models/

# Controllers
bundle exec rspec spec/requests/

# Teste específico
bundle exec rspec spec/requests/users/sessions_spec.rb
```

### Cobertura de testes

```bash
# Com coverage (se configurado)
COVERAGE=true bundle exec rspec
```

## 📡 Endpoints da API

### Base URL

```
http://localhost:3000
```

### Endpoints

#### 1. Criar conta (Sign Up)

```http
POST /signup
Content-Type: application/json

{
  "registration": {
    "first_name": "John",
    "last_name": "Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }
}
```

⚠️ Atenção: o uso da chave registration no corpo da requisição é obrigatório. O Devise foi configurado para receber os parâmetros aninhados em registration, e requisições fora desse padrão resultarão em erro de validação.

**Resposta de sucesso (201):**

```json
{
  "message": "Account created successfully",
  "data": {
    "user": {
      "id": 1,
      "email": "john@example.com",
      "first_name": "John",
      "last_name": "Doe",
      "full_name": "John Doe",
      "created_at": "2024-01-01T00:00:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  }
}
```

#### 2. Login

```http
POST /login
Content-Type: application/json

{
  "user": {
    "email": "john@example.com",
    "password": "password123"
  }
}
```

**Resposta de sucesso (200):**

```json
{
  "message": "Logged in successfully",
  "data": {
    "user": {
      "id": 1,
      "email": "john@example.com",
      "first_name": "John",
      "last_name": "Doe",
      "full_name": "John Doe",
      "created_at": "2024-01-01T00:00:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  }
}
```

#### 3. Perfil do usuário (Protegido)

```http
GET /me
Authorization: Bearer {token}
```

**Resposta de sucesso (200):**

```json
{
  "message": "User profile retrieved successfully",
  "data": {
    "id": 1,
    "email": "john@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "full_name": "John Doe",
    "created_at": "2024-01-01T00:00:00.000Z"
  }
}
```

#### 4. Logout

```http
DELETE /logout
Authorization: Bearer {token}
```

#### 5. Health Check

```http
GET /health
```

**Resposta (200):**

```json
{
  "status": "ok",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "version": "1.0.0"
}
```

## 🔐 Autenticação JWT

### Como funciona

1. **Signup/Login**: Retorna um token JWT válido por 24 horas
2. **Requests protegidos**: Incluir o token no header `Authorization: Bearer {token}`
3. **Token payload**: Contém `user_id`, `email` e `exp` (expiração)

### Exemplo de uso

```bash
# 1. Fazer login
curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d '{"user": {"email": "john@example.com", "password": "password123"}}'

# 2. Extrair o token da resposta
TOKEN="eyJhbGciOiJIUzI1NiJ9..."

# 3. Usar o token em requests protegidos
curl -X GET http://localhost:3000/me \
  -H "Authorization: Bearer $TOKEN"
```

## 🗂️ Estrutura do Projeto

```
auth_backend/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── health_controller.rb
│   │   ├── users_controller.rb
│   │   └── users/
│   │       ├── sessions_controller.rb
│   │       └── registrations_controller.rb
│   ├── models/
│   │   └── user.rb
│   └── serializers/
│       └── user_serializer.rb
├── config/
│   ├── routes.rb
│   ├── database.yml
│   └── initializers/
│       ├── cors.rb
│       └── devise.rb
├── spec/
│   ├── models/
│   │   └── user_spec.rb
│   ├── requests/
│   │   ├── users_spec.rb
│   │   └── users/
│   │       ├── sessions_spec.rb
│   │       └── registrations_spec.rb
│   ├── factories/
│   │   └── users.rb
│   └── support/
│       ├── jwt_helper.rb
│       └── database_cleaner.rb
└── README.md
```

## 🚨 Tratamento de Erros

### Erros de Validação (422)

```json
{
  "message": "User could not be created",
  "errors": [
    "Email can't be blank",
    "Password is too short (minimum is 6 characters)"
  ]
}
```

### Erro de Autenticação (401)

```json
{
  "error": "Invalid or expired token"
}
```

### Erro de Autorização (401)

```json
{
  "error": "Authorization token required"
}
```

## 📈 Comandos úteis

### Desenvolvimento

```bash
# Iniciar servidor
rails server

# Abrir console
rails console

# Rodar migrações
rails db:migrate

# Resetar banco
rails db:reset
```

### Testes

```bash
# Rodar todos os testes
bundle exec rspec

# Rodar testes com output detalhado
bundle exec rspec --format documentation

# Rodar testes específicos
bundle exec rspec spec/models/user_spec.rb
bundle exec rspec spec/requests/users/sessions_spec.rb
```

### Linting e Qualidade

```bash
# Rubocop (se configurado)
bundle exec rubocop

# Brakeman (análise de segurança)
bundle exec brakeman
```

## 🔍 Debug

### Logs

```bash
# Visualizar logs em tempo real
tail -f log/development.log

# Logs de teste
tail -f log/test.log
```

### Console Rails

```bash
rails console

# Testar criação de usuário
user = User.create(email: 'test@example.com', first_name: 'Test', last_name: 'User', password: 'password123')

# Testar JWT
payload = { user_id: user.id, email: user.email, exp: 24.hours.from_now.to_i }
token = JWT.encode(payload, ENV['DEVISE_JWT_SECRET_KEY'])
decoded = JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'])
```

## 🐳 Docker (Opcional)

### Dockerfile

```dockerfile
FROM ruby:3.2.0

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
```

### docker-compose.yml

```yaml
version: "3.8"
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
      POSTGRES_DB: auth_backend_development
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  api:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - db
    environment:
      - DB_HOST=db
      - DB_USERNAME=postgres
      - DB_PASSWORD=password
      - DEVISE_JWT_SECRET_KEY=your-secret-key
    volumes:
      - .:/app

volumes:
  postgres_data:
```

### Comandos Docker

```bash
# Buildar e iniciar
docker-compose up --build

# Rodar migrações
docker-compose run api rails db:migrate

# Rodar testes
docker-compose run api bundle exec rspec
```

## 📚 Próximos passos

1. **Implementar refresh tokens**
2. **Adicionar rate limiting**
3. **Implementar logs estruturados**
4. **Adicionar monitoramento**
5. **Configurar CI/CD**
6. **Adicionar documentação Swagger**

## 📝 Licença

Este projeto está sob a licença MIT.
