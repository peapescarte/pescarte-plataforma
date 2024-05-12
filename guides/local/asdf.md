# asdf

### Requerimentos mínimos

| requirement                                               | release |
| --------------------------------------------------------- | ------- |
| [docker](https://docs.docker.com/get-docker/)                 | 24.0.8+  |
| [docker-compose](https://github.com/docker/compose/releases/) | 2.19.0+  |
| [asdf](https://asdf-vm.com/)                              | 0.9.0+  |
| [asdf-postgres](https://github.com/smashedtoatoms/asdf-postgres#dependencies) | - |
| [asdf-elixir](https://github.com/asdf-vm/asdf-elixir#install)                 | - |
| [asdf-erlang](https://github.com/asdf-vm/asdf-erlang#install)                 | - |
| [supabase-cli](https://github.com/supabase/cli) | >= 1.122.0 |


---

### Processo inicial

Dentro do diretório do projeto, execute:

```sh
asdf install
```

Serão baixadas as versões exatas da `Erlang/OTP`, `Elixir` e `Postgres` usadas no projeto.

### Rodando o projeto pela primeira vez

Carrege as varáveis de ambiente contidas em `.env.dev`:
```sh
source .env.dev
```

Inicia os serviços do supabase (precisa do docker):
```sh
supabase start
```

Instale as dependências do projeto:

```sh
mix deps.get
```

Configure seu banco local em `config/dev.exs` e crie seu banco de dados junto com as migrations:

```sh
mix ecto.setup
```

### Sempre que for rodar o projeto

Inicie os serviços da supabase:
```sh
supabase start
```

Suba o servidor do `Phoenix` normalmente:

```sh
iex -S mix phx.server
```

O servidor estará disponível em `localhost`, na porta `4000`.

### Para executar migrações

```sh
mix ecto.migrate
```

### Para reverter migrações

```sh
mix ecto.rollback
```

### Para recriar o banco de dados

```sh
mix ecto.reset
```

---

## Rodando os testes

Para rodar os testes localmente execute o comando:

```sh
mix test
```

E para rodar todos os testes (`format`, `credo` e `test`) use:

```sh
mix ci
```

É recomendável rodar os testes unitários sem efetuar a recriação do DB, pois o tempo de execução será
sempre menor. Porém, se o banco de testes ficar em um estado em que os dados presentes influenciem na
execução dos testes com sucesso, é recomendado recriá-lo.
Para recriar o banco de testes, rodar as seeds e os testes unitários
(`ecto.drop`, `ecto.create`, `ecto.migrate`, `seeds` e `test`) execute:

```sh
mix test.reset
```
