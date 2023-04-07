# Contribuindo com a API PEA Pescarte

👍🎉 Primeiro de tudo, muito obrigado por despender tempo em contribuir com esse projeto! Espero que tenha uma experiência incível! 👍🎉

## Requisitos e Ambiente de Desenvolvimento

Siga os passos descritos na seção de `Setup`, no [README](./README.md#primeira-vez-rodando)!

## Estrutura da Aplicação

```sh dark
.
├── config/
├── guides/
├── lib/
├── mix.exs
├── mix.lock
├── priv/
├── rel/
└── test/
```

- `config` - neste diretório se encontra toda a configuração do projeto, o arquivo `config/config.exs` é a porta de entrada da config e no final dele são importadas as configurações específicas de ambiente como `dev`, `test` ou `prod`. Essa configuração é executada em tempo de compilação. Por fim, o arquivo `config/runtime.exs` é executado; este arquivo é ideal para pegar valores dinâmicos, de variáveis de ambiente, por exemplo. Como o nome do arquivo diz, essa configuração é processada em tempo de execução.
- `guides` - neste diretório se encontra os guias para diferentes formas de configuração do ambiente de desenvolvimento local, guias de padronização de código como formatado dos testes automatizados, dentre outras recomendações e padrões utilizados no projeto.
- `lib` - diretório onde se encontra o código fonte da aplicação. Dentro dele existem dois subdiretórios, `lib/pescarte` e `lib/pescarte_web`. O diretório `lib/pescarte` é responsável por denominar e guardar a implementação das regras de negócio e domínios de negócio da aplicação. Geralmente é onde se comunica com a base de dados. Já `lib/pescarte_web` é responsável por expor o domínio de negócio para o externo, geralmente sendo uma aplicação web, e mais especificamente, uma API `GraphQL`.
- `mix.exs` - arquivo de configuração do projeto como um todo! Entenda como se fosse um `package.json` dentro do ecossistema `JavaScript`. Aqui definimos o nome da aplicação, listamos suas dependências, configuramos como a aplicação deve ser compilada e gerada sua versão final e também configuramos os dados para gerar documentação do projeto.
- `mix.lock` - arquivo onde é guardado as versões atuais das dependências baixadas, gerando reprodutibilidade no ambiente. Entenda como um `yarn.lock` ou `package-lock.json` do ecossistema `JavaScript`.
- `rel` - diretório onde são definidos scripts que serão executados quando a aplicação for gerar sua versão final
- `test` - diretório onde se encontram todos os testes automatizados, sejam eles unitários ou de integração. Geralmente sua estrutura interior replica a subestrutura encontrada em `lib`

### Diretório lib/pescarte

```sh dark
lib/pescarte
├── application.ex
├── database.ex
├── domains/
├── helpers.ex
├── http_client.ex
├── http_client_behaviour.ex
├── release.ex
├── repo.ex
└── types/
```

- `application.ex` - este arquivo representa o ponto de inicío da nossa aplicação! É onde são definidas as aplicações que nosso projeto depende, como conexão com banco de dados, cliente HTTP distribuído, entre outros. Cada aplicação listada aqui é uma aplicação Elixir e e gerenciada por [Supervisors](https://hexdocs.pm/elixir/Supervisor.html), que fornece a tolerância a falhas pra nossa aplicação como um todo e suas dependências.
- `database.ex` - é uma abstração sobre as funções do [Ecto.Repo](https://hexdocs.pm/ecto/Ecto.html#module-repositories), centralizando todas as chamandas ao banco em 1 (um) único arquivo. Assim torna-se mais fácil de testar e isolar os efeitos colaterais da aplicação.
- `domains` - diretório onde se encontra os domínios de negócio da aplicação! Será melhor explicado na próxima seção
- `helpers.ex` - neste arquivo são definidas funções comuns e [puras][pure-functions] que transformam dados da aplicação e padronizão os retornos
- `http_client_behaviour.ex` - comportamento que define as funções necessárias para implementar um cliente HTTP, para realizar requisições a outros serviços e APIs externas! Entenda como uma interface do `TypeScript` ou `Java`. Para ler mais sobre comportamentos, siga a [documentação oficial da linguagem Elixir](https://hexdocs.pm/elixir/typespecs.html#behaviours)
- `http_client.ex` - arquivo no qual o comportamento `http_client_behaviour` é implementado, permite realizar requições HTTP externas a aplicação

#### Diretório lib/pescarte/domains

```sh dark
lib/pescarte/domains
└── modulo_pesquisa
    ├── io
    ├   └──repo
    ├── models
    ├── modulo_pesquisa.ex
    └── services
```

Neste diretório se encontra os domínios de negócio da aplicação. Em outras palavras, cada domínio representa um contexto fechado no qual necessita de uma solução na vida real. Cada domínio é dividido em "camadas", onde a camada mais interna só pode ser acessada pela a camada superior direta. A imagem a seguir exemplifica isso:

<p align="center">
  <img src="https://user-images.githubusercontent.com/44469426/230610574-3eccf5d7-baca-4b0c-afed-f37e735bfd72.png" />
</p>

Cada domínio de negócio possui os seguintes componentes:

- `io` - diretório onde se encontra execuções e soluções que causam efeitos colaterais, como comunicação com banco de dados ou envio de emails por exemplo
  - `repo` - neste diretório é implementado as funções específicas de cada entidade para o CRUD (create, read, update e delete). Cada modelo de domínio possui seu próprio repositório com funções específicas
- `models` - diretório que representa os modelos de negócio, as entidades do domínio! Por exemplo, no caso od domínio `modulo_pesquisa`, temos as entidades `Pesquisador` e `Relatorio`. Os modelos são os componentes mais importantes dentro de um domínio e não podem ser acessados diretamente por outros domínios nem mesmo por outros componentes do mesmo domínio
- `modulo_pesquisa.ex` - esse é o ponto de entrada do domínio/contexto da aplicação! Aqui é exposta a API pública dos serviços internos desse domínio e é a única forma de se comunicar com outros domínios ou outros pontos da aplicação, como a camada web
- `services` - neste diretório se encontra 2 (dois) tipos de caso de uso, ou chamados "serviços".
  - `domain_services` - são serviços que modificam os modelos/entidades do domínio. É a única camada que pode modificar os modelo de forma direta e é importante ressaltar que os serviços de domínio podem apenas implementar [funções puras][pure-functions], sem efeitos colaterais. Um serviço de domínio pode modificar uma ou mais entidades
  - `application_service` - este serviço funciona como uma "cola" para todos os outros componentes do domínio de negócio. Aqui será criado o fluxo de uma ação real do domínio. Por exemplo, na criação de uma entidade, é necessário fazer a validação de uma entidade (cargo do serviço de domínio) e inserí-la, caso válida, no banco de dados (cargo do componente io).

### Diretório lib/pescarte_web

```sh dark
lib/pescarte_web
├── endpoint.ex
├── graphql
├── plugs
└── router.ex
```

- `endpoint.ex` - este arquivo é o ponto de entrada da camada web da aplicação! Nele é configurado o reteador da aplciação, opções de sessão web, diferentes leitores de formatos como `JSON` ou `HTML`, dentre outras opções.
- `graphql` - neste diretório é implementado os esquemas, entidades e mutações possíveis da API `GraphQL` da aplicação. O mesmo será explicado em mais detalhes na próxima seção
- `plugs` - neste diretório se encontra arquivos que modificam a componentes da conexão durante o fluxo da requisição na aplicação. Entenda como um [middleware][middleware]! Porém os `Plugs` dentro do framework `Phoenix` podem ser adicionados em qualquer ponto do ciclo de vida de uma requição, como no início, meio (middleware) ou no fim, antes de ser enviada uma resposta ao cliente. Para mais informações, leia a documentação de [Plugs](https://hexdocs.pm/plug/readme.html)
- `router.ex` - neste arquivo são definidas as rotas que podem ser acessadas na aplicação!

#### Diretório lib/pescarte_web/graphql

```sh dark
lib/pescarte_web/graphql
├── context.ex
├── middlewares
├── resolvers
├── schema.ex
└── types
```

- `context.ex` - arquivo onde se implementa informações que precisam estar disponível de forma "global" para as requisições `GraphQL`, por exemplo, uma pessoa usuária caso autenticada é disponibilizada neste arquivo e inserida no contexto de toda requisição, assim sendo possível implementar autorização
- `middlewares` - neste diretório se encontra [middlewares][middleware] específicos para as requisições `GraphQL`
- `resolvers` - neste diretório são implementadas as [resoluções][resolver] para cada entidade do esquema `GraphQL` da aplicação. Entenda uma resolução como um [Controller][controller] em APIs REST
- `schema.ex` - este arquivo implementa o esquema público que será exposto na API `GraphQL`. Nele é especificado quais entidades e quais [consultas][queries] e [mutações][mutations] estão disponíveis para modificar as entidades
- `types` - neste diretório é implementado os tipos de cada entidade e esquemas de como os argumentos de cada entidade devem ser recebidos. Leia mais na documentação sobre [esquemas][schemas]

## Como contribuir?

Serão abertas issues de diferente escopos, como:

- implementar novos contextos e entidades
- refatorar contextos e excluir partes desnecessárias
- corrigir bugs de algum fluxo existente
- expor as queries e mutations necessárias para alimentar o frontend

Em adição as issues, existem dois projetos do GitHub com as tarefas atuais, distribuídas num quadro estilo [Kaban](https://www.alura.com.br/artigos/metodo-kanban).

Um projeto é específico para os componentes do Design System e o outro é um projeto para tarefas gerais da plataforma, incluindo correção de bugs e implementação de telas.

### Passos para pegar uma tarefa

Após encontrar uma tarefa do seu interesse na seção de [issues](https://github.com/peapescarte/pescarte-api/issues), adicione um comentário na issue da mesma, informando que irá trabalhar nela!

Crie uma branch no formato `<user-github>/tarefa`, exemplo:

- Usuário no github: `zoedsoupe`
- Tarefa: `Criar componente de botão`

Nome da branch: `zoedsoupe/cria-componente-botao`

### Abrindo a PR

Com a tarefa implementada, abra uma PR diretamente para a branch `main`. A mesma deve seguir o formato do template.

Assim que possível a [@zoedsoupe](https://github.com/zoedsoupe) irá revisar sua PR que poderá ser aprovada ou ter solicitação de refatoração.

Lembre-se que é que não é obrigatório testes unitários para uma PR ser aberta! Caso não saiba como implementar os mesmo, a [@zoedsoupe](https://github.com/zoedsoupe) irá te ajudar no processo!

## Documentos

### Modelagem do banco de dados (07/04/2023)

<p align="center">
  <img src="https://user-images.githubusercontent.com/44469426/230612648-fe09057e-8a29-436e-9526-6694e064313a.png" />
</p>

### Regras de Negócio

<!-- TODO -->

Em construção...

## Links para referência e estudo

### Elixir e programação

Tenho um servidor no `Discord` onde centralizei dezenas de links não apenas sobre Elixir mas sobre programação web para backend como um todo, tendo banco de dados, APIs, git w github, sistemas operacioanis e muito mais.

Entrem no servidor por [esse](https://discord.gg/b9wrZbq4rh) link e sigam as trilhas dos canais "fullstack" e "backend".

- [Guia de início oficial em Elixir (en)](https://elixir-lang.org/getting-started/introduction.html)
- [Documentação oficial GraphQL (en)](https://graphql.org/learn/)
- [Artigo sobre a arquitetura "Clan" ou "Explícita" - 3 partes (en)](https://milan-pevec.medium.com/the-only-constant-is-a-change-or-how-the-explicit-architecture-can-save-the-day-part-i-85da40dafc64)
- [Canal do Adolfo Neto, sobre Elixir, Erlang e a BEAM (pt-br)](https://www.youtube.com/c/ElixirErlangandtheBEAMwithAdolfoNeto?app=desktop)
- [Documentação oficial Elixir (en)](https://hexdocs.pm/elixir)
- [Documentação oficial Phoenix (en)](https://www.phoenixframework.org/)
- [Elixir do zero, acesso a API, banco de dados e testes (pt-br)](https://www.youtube.com/watch?v=DvBB9cnmNKg)
- [Elixir - banco de dados com Ecto (pt-br)](https://www.youtube.com/watch?v=tjvwsxjvBwY)
- [Documentação oficial Ecto - biblioteca para banco de dados (en)](https://hexdocs.pm/ecto)
- [Conheça as estruturas de dados em Elixir (pt-br)](https://www.youtube.com/watch?v=itY9IVnvgmw)
- [Comunidade de Elixir no telegram, para dúvidas e discussões (pt-br)](https://t.me/elixirbr)
- [Fluxo de controle em Elixir de forma limpa com casamento de padrões (en)](https://elixirschool.com/blog/clean-control-flow-in-elixir-with-pattern-matching-and-immutability/)
- [Colinha do módulo Elixir Enum](https://www.youtube.com/watch?v=8Jod6wIF6_M)
- [Elixir em foco - o podcast da comunidade brasileira de Elixir (pt-br)](https://elixiremfoco.com/)
- [Escrevendo Elixir extensível (en)](https://gist.github.com/rranelli/430ddbb2b682f20b3fd2d981e4786f3d)
- [Trilha de Elixir no Exercism - site para aprender linguagens de programação (en)](https://exercism.org/tracks/elixir/exercises)
- [Phoenix, o melhor framework web (pt-br)](https://www.youtube.com/watch?v=zhTisehGoV8)
- [Construindo uma API JSON com Phoenix (en)](https://www.youtube.com/watch?v=X9AggnaEXrM)
- [Tutorial Elixir e Phoenix (en)](https://www.youtube.com/playlist?list=PLJbE2Yu2zumAgKjSPyFtvYjP5LqgzafQq)
- [CRUD completo com Phoenix (pt-br)](https://www.youtube.com/watch?v=rhl_nwgY5uw)
- [Elixir - uma linguagem brasileira para sistemas distribuídos](http://www.each.usp.br/petsi/jornal/?p=2459)
- [ElixirSchool - lições sobre Elixir (pt-br)](https://elixirschool.com/pt/)
- [Desenvolvendo sistemas com Elixir (pt-br)](https://www.youtube.com/watch?v=mV_C5wpIowg)
- [Palestra Elixir of life (pt-br)](https://www.youtube.com/watch?v=8Ng6TfAj7Sk)
- [The Soul of Elixir (en)](https://youtu.be/JvBT4XBdoUE)
- [Principios de progrmação funcional com Elixir (en)](https://www.youtube.com/watch?v=Zee4bbsDvrA)
- [Mistérios do GenServer com Willian Frantz (pt-br)](https://www.youtube.com/watch?v=wU4FH5f1v4Q&list=PL8Vfm2INuMLEtQGcBTXZMqjTQqZl5EbJt&index=16)
- [Forum oficial do Elixir - faça perguntas e tirem dúvidas (en)](https://elixirforum.com/)
- [Como começar a aprender Elixir? (pt-br)](https://dev.to/elixir_utfpr/como-comecar-a-aprender-a-linguagem-de-programacao-elixir-26o5)
- [TDD com Elixir (pt-br)](https://dev.to/elixir_utfpr/tdd-com-elixir-2bb6)
- [Funções em Elixir como associações ou como "receitas" (pt-br)](https://dev.to/elixir_utfpr/funcoes-em-elixir-como-associacoes-de-valores-ou-como-receitas-44c2)
- [Use pipes em Elixir sempre que possível](https://dev.to/elixir_utfpr/use-canos-pipes-sempre-que-possivel-em-elixir-25ci)
- [Elixir - básico (pt-br)](https://www.youtube.com/watch?v=2weVIXHyIwI)
- [Introdução a programação funcional com Elixir (pt-br)](https://www.youtube.com/watch?v=kf76jynaiZ0)
- [Introdução a programação com Elixir (pt-br)](https://www.youtube.com/watch?v=wJoo7Yicu5g&start=2)
- [Curso de Banco de Dados (pt-br)](https://www.youtube.com/playlist?list=PL4Sl6eAbMK7RSdXPe8lZ7s-xSitGHH4RZ)
- [SQL sem mistério (pt-br)](https://www.youtube.com/playlist?list=PL6D9EMPMNdExSDbnRfwNhdTq1C1UQryo3)

### Ferramentas para desenvolvimento backend

- [Insomnia - cliente HTTP](https://insomnia.rest/download)
- [Beekeeper studio - visualizador de banco de dados](https://www.beekeeperstudio.io/)

[pure-functions]: https://natahouse.com/pt/qual-e-a-melhor-maneira-de-utilizar-as-funcoes-puras
[middleware]: https://stackoverflow.com/a/2257031/10564213
[controller]: https://www.lewagon.com/pt-BR/blog/o-que-e-padrao-mvc
[resolver]: https://graphql.org/learn/execution/#root-fields-resolvers
[queries]: https://graphql.org/learn/queries/
[mutations]: https://graphql.org/learn/queries/#mutations
[schemas]: https://graphql.org/learn/schema/
