# Nix

### Requisitos mínimos

| requirement                                               | release |
| --------------------------------------------------------- | ------- |
| [nix](https://nixos.org/)                                 | 2.5.1+  |
| [direnv](https://direnv.net/)                             | 2.28.0+ |
| [supabase-cli](https://github.com/supabase/cli) | >= 2.15.0 |

---

### Processo inicial

Dentro do diretório do projeto, execute:

```sh
direnv allow
```

O ambiente local será baixado e compilado usando [nix-flakes](https://nixos.wiki/wiki/Flakes#:~:text=Nix%20Flakes%20are%20an%20upcoming,inputs%20%3D%20%7B%20home%2Dmanager.).

### Sempre que for rodar o projeto

Inicie os serviços da supabase (é necessário ter o Docker instalado):
```sh
supabase start
```

E suba o servidor do `Phoenix` normalmente:
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

É recomendável rodar os testes unitários sem recriar o banco de dados, pois o tempo de execução será sempre menor. No entanto, se o banco de testes ficar em um estado em que os dados presentes influenciem negativamente na execução bem-sucedida dos testes, é recomendável recriá-lo.
Para recriar o banco de testes, rodar as seeds e os testes unitários (`ecto.drop`, `ecto.create`, `ecto.migrate`, `seeds` e `test`), execute:

```sh
mix test.reset
```
