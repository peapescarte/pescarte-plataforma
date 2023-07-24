# Modulo Pesquisa

Aplicação responsável pelo cadastro e gerenciamento da parte administrativa da plataforma PEA Pescarte.

A aplicação respeita a arquitetura explícita, onde temos:

1. `handlers/`
2. `models/`
3. `repository.ex`
4. `services/`

## Handlers

Basicamente são controllers, que expõe uma API pública do contexto/app para que outras aplicações possam usar! Cada `handler` deve respeitar um [comportamento/interface](https://elixirschool.com/pt/lessons/advanced/behaviours) e se restringir a um sub-domínio da aplicação.

### MidiasHandler

Código fonte pode ser visto [aqui](./lib/modulo_pesquisa/handlers/midias_handler.ex)

```elixir
MidiasHandler.create_categoria/1
MidiasHandler.create_midia/1
MidiasHandler.create_midia_and_tags/2
MidiasHandler.create_tag/1
MidiasHandler.create_multiple_tags/2
MidiasHandler.fetch_categoria/1
MidiasHandler.fetch_midia/1
MidiasHandler.list_categoria/0
MidiasHandler.list_midia/0
MidiasHandler.list_midias_from_tag/1
MidiasHandler.list_tag/0
MidiasHandler.list_tags_from_categoria/1
MidiasHandler.list_tags_from_midia/1
MidiasHandler.remove_tags_from_midia/2
MidiasHandler.update_midia/1
MidiasHandler.update_tag/1
```

## Models

São definidos os  modelos/entidades da aplicação, e devem ser a fonte da verdade do contexto. Podem representar tabelas de um banco de dados ou entidades mais abstratas.

- [Campus](./lib/modulo_pesquisa/models/campus.ex)
- [Linha Pesquisa](./lib/modulo_pesquisa/models/linha_pesquisa.ex)
- [Midia](./lib/modulo_pesquisa/models/midia.ex)
  - [Categoria](./lib/modulo_pesquisa/models/midia/categoria.ex)
  - [Tag](./lib/modulo_pesquisa/models/midia/tag.ex)
- [Nucleo Pesquisa](./lib/modulo_pesquisa/models/nucleo_pesquisa.ex)
- [Pesquisador](./lib/modulo_pesquisa/models/pesquisador.ex)
- [Relatorio Anual Pesquisa](./lib/modulo_pesquisa/models/relatorio_anual_pesquisa.ex)
- [Relatorio Mensal Pesquisa](./lib/modulo_pesquisa/models/relatorio_mensal_pesquisa.ex)
- [Relatorio Trimestral Pesquisa](./lib/modulo_pesquisa/models/relatorio_trimestral_pesquisa.ex)

## Repository

Arquivo responsável por definir funções que interagem diretamente com o banco de dados, como inserção ou consultas.

## Services

Casos de uso, onde se concentram arquivos de lógica de negócio. Podem modificar entidades e são constituidos apenas por funções puras.
