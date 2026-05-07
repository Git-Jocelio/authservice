# AuthService

API de autenticação desenvolvida em Delphi para validação de usuários via LDAP integrado ao Active Directory do Windows.

## Objetivo

O projeto AuthService tem como objetivo centralizar autenticação corporativa utilizando protocolo LDAP, permitindo que aplicações externas validem usuários diretamente no Active Directory através de uma API REST simples e segura.

---

# Tecnologias Utilizadas

- Delphi
- Horse Framework
- LDAP
- Active Directory (AD)
- REST API
- JSON

---

# Estrutura do Projeto

```text
AuthService/
│
├── config/
├── docs/
├── src/
│   ├── controller/
│   ├── model/
│   ├── provider/
│   ├── routes/
│   ├── service/
│   ├── utils/
│   └── fontes/
│
├── bin/
├── logs/
└── temp/
```

---

# Fluxo de Autenticação

1. Cliente envia login e senha para API
2. API recebe requisição REST
3. Serviço LDAP realiza conexão com Active Directory
4. Credenciais são validadas
5. API retorna resultado em JSON

---

# Endpoint de Login

## Request

```http
POST /login
```

## Exemplo de Requisição

```json
{
  "login": "usuario",
  "password": "senha"
}
```

---

# Resposta de Sucesso

```json
{
  "success": true,
  "message": "Usuário autenticado com sucesso"
}
```

---

# Resposta de Erro

```json
{
  "success": false,
  "message": "Usuário ou senha inválidos"
}
```

---

# Ambiente de Testes

## Local

```http
POST http://localhost:9000/login
```

## Produção

```http
POST https://authservice:443/login
```

---

# Configurações LDAP

As configurações de conexão LDAP ficam centralizadas nos arquivos de configuração da aplicação.

Exemplo:

```ini
LDAP_HOST=
LDAP_PORT=
LDAP_DOMAIN=
LDAP_BASE_DN=
```

---

# Objetivos Futuros

- Geração de JWT
- Middleware de autenticação
- Logs estruturados
- Docker
- HTTPS
- Monitoramento
- Integração com múltiplos domínios AD

---

# Status do Projeto

Projeto em desenvolvimento.

---

# Autor

Jocelio Gomes da Silva
