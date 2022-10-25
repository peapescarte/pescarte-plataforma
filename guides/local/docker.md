# Docker

### Requerimentos mínimos

| requirement                                                   | release  |
| ------------------------------------------------------------- | -------- |
| [docker](https://docs.docker.com/get-docker/)                 | 20.10.8+ |
| [docker-compose](https://github.com/docker/compose/releases/) | 2.0.0+   |

---

### Processo inicial

Antes de iniciar o processo de build dos containers no Docker, é necessário forçar a versão do
`DOCKER_BUILDKIT` e `COMPOSE_DOCKER_CLI_BUILD` para `0`, de forma que não haja erros neste
processo. Para facilitar essa configuração, defina essas variáveis na inicialização do seu shell,
ex: `~/.bash_profile`, `~/.zshrc`, `~/fish/config.fish` etc:

```sh
DOCKER_BUILDKIT=0
COMPOSE_DOCKER_CLI_BUILD=0
```

Como a opçã̀o padrã̀o para executar o projeto é com `Nix`, é necessário criar um arquivo `local.secret.exs` na pasta `config` com o seguinte conteúdo:
```elixir
import Config

config :pescarte, Pescarte.Repo,
  hostname: "db"
```

 Em seguida, execute o build dos containers e obtenha as dependencias do `mix`.

    docker-compose build
    docker-compose run --rm pescarte mix deps.get

Depois, basta rodar o setup do banco de dados.

    docker-compose run --rm pescarte mix ecto.setup

### Sempre que for rodar o projeto

    docker-compose up

### Para atualizar ou instalar novas dependências

    docker-compose run --rm pescarte mix deps.get

### Para executar migrações

    docker-compose run --rm pescarte mix ecto.migrate

### Para reverter migrações

    docker-compose run --rm pescarte mix ecto.rollback

### Para recriar o banco de dados

    docker-compose run --rm pescarte mix ecto.reset

### Portas expostas no sistema do host

| container     | port |
| ------------- | ---- |
| pescarte       | 4000 |
| db            | 5432 |

---

## Rodando os testes

Para rodar os testes localmente execute o comando:

    docker-compose run --rm pescarte mix test

E para rodar todos os testes (`format`, `credo` e `test`) use:

    docker-compose run --rm pescarte mix ci

É recomendável rodar os testes unitários sem efetuar a recriação do DB, pois o tempo de execução será
sempre menor. Porém, se o banco de testes ficar em um estado em que os dados presentes influenciem na
execução dos testes com sucesso, é recomendado recriá-lo.
Para recriar o banco de testes, rodar as seeds e os testes unitários
(`ecto.drop`, `ecto.create`, `ecto.migrate`, `seeds` e `test`) execute:

    docker-compose run --rm pescarte mix test.reset
