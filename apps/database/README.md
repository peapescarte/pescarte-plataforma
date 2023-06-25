# Database

Aplicação responsável por gerenciar as conexões com o banco de dados.

Atualmente existem dois tipos de conexão:

1. Escrita: Usada para ações de inserção, atualização ou remoção
2. Leitura: Usada apenas para consultas

## Como usar

Após criar uma nova aplicação com `mix new <nome-app>`, adicione este app como dependência:

```elixir
  defp deps do
    [
      {:database, in_umbrella: true}
    ]
  end
```

Agora é possivel definit modelos e módulo de repositorio:

```elixir
defmodule MeuApp.Models.MeuModelo do
  use Database, :model

  # ...
end
```

```elixir
defmodule MeuApp.Repository do
  use Database, :repository

  # ...
end
```

Em adição as definições, também foram definidas funções para facilitar o casamento de padrões (pattern matching) no retorno delas:

```elixir
Database.fetch(read_repo(), MeuModelo, chave_primaria)
Database.fetch_one(read_repo(), query)
Database.fetch_by(read_repo(), MeuModelo, coluna)
```
