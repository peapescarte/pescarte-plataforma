# Docker

### Requerimentos mínimos

| requirement                                                   | release  |
| ------------------------------------------------------------- | -------- |
| [docker](https://docs.docker.com/get-docker/)                 | 24.0.8+  |
| [docker-compose](https://github.com/docker/compose/releases/) | 2.19.0+  |
| [supabase-cli](https://github.com/supabase/cli) | >= 1.122.0 |

---

### Processo inicial

Como a opção padrão para executar o projeto é com `Nix`, você pode controlar as configurações do postgresql via variáveis de ambiente, caso execute apenas o container do projeto. Caso esteja usando `docker compose`, todas essas variáveis já são automaticamente configuradas:

- `DATABASE_HOST`
- `DATABASE_PASSWORD`
- `DATABASE_USER`
- `PG_DATABASE`

tanto nos ambiente de teste quanto para desenvolvimento.

Em seguida, execute o build dos containers.

```console
$ docker compose build
```

Inicie os serviços da supabase:
```sh
supabase start
```

Depois, basta rodar o setup.

```console
$ docker compose up
```

Dessa forma, o setup do banco, bem como todas as dependências serão instaladas e compiladas.

### Sempre que for rodar o projeto

Inicie os serviços da supabase:
```sh
supabase start
```

Depois,
```console
$ docker compose up
```

Ou caso precise de um REPL interativo com `iex`:

```console
$ docker compose run --rm pescarte
```

### Para atualizar ou instalar novas dependências

```console
$ docker compose run --rm pescarte mix deps.get
```

### Para executar migrações

```console
$ docker compose run --rm pescarte mix ecto.migrate
```

### Para reverter migrações

```console
$ docker compose run --rm pescarte mix ecto.rollback
```

### Para recriar o banco de dados

```console
$ docker compose run --rm pescarte mix ecto.reset
```

### Portas expostas no sistema do host

| container     | port |
| ------------- | ---- |
| pescarte      | 4000 |
| database      | 5432 |

---

## Rodando os testes

Para rodar os testes localmente execute o comando:

```console
$ docker compose run --rm pescarte mix test
```

É recomendável rodar os testes unitários sem efetuar a recriação do DB, pois o tempo de execução será sempre menor. Porém, se o banco de testes ficar em um estado em que os dados presentes influenciem na execução dos testes com sucesso, é recomendado recriá-lo.
