# Identidades

Aplicação responsável pelo cadastro e gerenciamento de pessoas usuárias e dados pessoais. Também tem responsabilidade de gerenciar tokens de usuário, usados para criar sessões web, por exemplo.

A aplicação respeita a arquitetura explícita, onde temos:

1. `handlers/`
2. `models/`
3. `repository.ex`
4. `services/`

## Handlers

Basicamente são controllers, que expõe uma API pública do contexto/app para que outras aplicações possam usar! Cada `handler` deve respeitar um [comportamento/interface](https://elixirschool.com/pt/lessons/advanced/behaviours) e se restringir a um sub-domínio da aplicação.

### CredenciaisHandler

Código fonte pode ser visto [aqui](./lib/identidades/handlers/credenciais_handler.ex)

```elixir
CredenciaisHandler.confirm_usuario/2
CredenciaisHandler.delete_session_token/1
CredenciaisHandler.fetch_usuario_by_reset_password_token/1
CredenciaisHandler.fetch_usuario_by_session_token/2
CredenciaisHandler.generate_email_token/2
CredenciaisHandler.generate_session_token/1
CredenciaisHandler.update_usuario_password/3
CredenciaisHandler.reset_usuario_password/2
```

### UsuarioHandler

Código fonte pode ser visto [aqui](./lib/identidades/handlers/usuario_handler.ex)

```elixir
UsuarioHandler.create_usuario_admin/1
UsuarioHandler.create_usuario_pesquisador/1
UsuarioHandler.fetch_usuario_by_id_publico/1
UsuarioHandler.fetch_usuario_by_cpf_and_password/2
UsuarioHandler.fetch_usuario_by_email_and_password/2
UsuarioHandler.list_usuario/0
```

## Models

São definidos os  modelos/entidades da aplicação, e devem ser a fonte da verdade do contexto. Podem representar tabelas de um banco de dados ou entidades mais abstratas.

- [Contato](./lib/identidades/models/contato.ex)
- [Endereço](./lib/identidades/models/endereco.ex)
- [Token](./lib/identidades/models/token.ex)
- [Usuário](./lib/identidades/models/usuario.ex)

## Repository

Arquivo responsável por definir funções que interagem diretamente com o banco de dados, como inserção ou consultas.

## Services

Casos de uso, onde se concentram arquivos de lógica de negócio. Podem modificar entidades e são constituidos apenas por funções puras.
