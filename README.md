# PEA Pescarte

[![lint](https://github.com/peapescarte/pescarte-api/actions/workflows/lint.yml/badge.svg)](https://github.com/peapescarte/pescarte-api/actions/workflows/lint.yml)
[![test](https://github.com/peapescarte/pescarte-api/actions/workflows/test.yml/badge.svg)](https://github.com/peapescarte/pescarte-api/actions/workflows/test.yml)

------------------------------------------------------------------------

## Setup Ambiente de desenvolvimento

### Primeira vez rodando

Este projeto possui três opções para ambientes de desenvolvimento:

1.  [Docker](./guides/local/docker.md)
2.  [Nix](./guides/local/nix.md)
3.  [asdf](./guides/local/asdf.md)

## Estrutura do projeto

- `/assets`: Armazena recursos estáticos como imagens, folhas de estilo e scripts que são usados pela aplicação web.
- `/config`: Inclui arquivos de configuração para diferentes ambientes de execução do projeto, controlando aspectos como conexões de banco de dados e outras variáveis de ambiente.
- `/guides`: Contém documentos e guias auxiliares para novos desenvolvedores, incluindo instruções de configuração, operações comuns e melhores práticas.
- `/lib`: O coração do projeto, onde reside a maior parte do código fonte da aplicação, incluindo módulos e funções da aplicação.
  - `/pescarte`: Módulos e funções que implementam lógica do servidor e interação com o banco de dados. É onde reside a lógica de negócio.
  - `/pescarte_web`: Onde reside a camada web da aplicação, contendo rotas, páginas, componentes visuais e lógicas aplicadas à UI.
- `/priv`: Diretório para dados privados que não são expostos no controle de versão, como scripts de migração do banco de dados.
- `/rel`: Contém scripts e configurações necessárias para gerar releases da aplicação, permitindo a compilação de builds que podem ser distribuídas e executadas em ambientes de produção.
- `/test`: Inclui testes de software, fundamental para garantir a qualidade e a estabilidade do código através de testes automatizados.

------------------------------------------------------------------------

## Guias

-   [Testes](./guides/tests.md)
-   [Testes de integração](./guides/integration_tests.md)

## Por que usar Elixir?

<a id="why-elixir" />

[Elixir][ elixir-site ] é uma [linguagem funcional][ functional-prog ], criada em 2011 pelo José Valim. Ela é baseada na [BEAM][ beam-meaning ], a máquina virtual do [Erlang][ erlang-meaning ]. O Erlang é conhecido por ser uma linguagem robusta, perfeita para aplicações que necessitam ser tolerantes à falhas, concorrentes - aproveitando todo o potencial da máquina - e escaláveis.

O [Elixir][ elixir-site ] surgiu com a proprosta de modernizar a sintaxe do [Erlang][ erlang-meaning ], que é fortemente herdada de [Prolog][ prolog-meaning ] - uma linguagem do paradigma lógico - e adicionar um gerenciador de depêndencias. Elixir e Erlang não são linguagens funcionais porque querem ser, e sim pois a concorrência e paralelismo num programa [POO][ oop-meaning ], [mutável][ immutability ] e [imperativo][ imperative-prog ], torna o gerenciamento das [threads][ thread-meaning ] algo que beira o impossível.

Vantagens da programação funcional:

- Imutabilidade
- Melhor testabilidade
- Programação declarativa
- Sintaxe mais humanamente amigável
- Funções puras, sem efeitos colaterais

### Diferença entre Concorrência e Paralelismo em Computação

<a id="concurrency-parallelism" />

Imagine uma máquina de venda de refrigerantes, onde apenas uma lata sai por vez, ou seja, apenas uma pessoa pode ser "atendida" após a outra. Com o tempo, forma-se uma fila para comprar refrigerante, onde cada pessoa retira seu item e vai embora. Neste caso, temos um modelo de programação linear.

Fazendo a correlação deste cenário onde a máquina de refrigerante representa a [CPU][ cpu-meaning ] do computador e a fila de pessoas representa a fila de [processos](<https://pt.wikipedia.org/wiki/Processo_(inform%C3%A1tica)>) os quais essa CPU executa.

Agora imagine que temos 2 (duas) máquinas de refrigerante - ou seja, duas CPUs, ou de forma mais realista, dois [núcleos](https://canaltech.com.br/hardware/como-ativar-os-nucleos-do-processador/) dentro da CPU - e agora cada máquina de refrigerante possui sua própria fila de pessoas - processos da CPU. Neste caso, chamamos esse modelo de computação de [_Paralelismo_][ paralel-meaning ].

Num último caso, imagine que existe apenas 1 (uma) máquina de refrigerante (CPU) porém essa máquina é capaz de atender múltiplas filas de pessoas (processos), ou seja, mais de uma pessoa pode retirar seu item ao mesmo tempo da máquina. Para esse modelo de computação damos o nome de [_Concorrência_][ concurrency-meaning ].

A imagem a seguir exemplifica os conceitos de _Paralelismo_ e _Concorrência_:

<p align="center">
 <img src="https://user-images.githubusercontent.com/44469426/230241225-60c9ac79-302d-4a19-96bd-b76585c5b902.png" />
</p>

### BEAM - máquina virtual do Erlang

<a id="beam" />

A [BEAM][ beam-meaning ] é a máquina virtual do [Erlang][ erlang-meaning ] (assim como a [JVM][ jvm-meaning ] do [JAVA][ java-meaning ]). Seu funcionamento básico é: ela divide cada ação do seu programa em pequenas ações, chamados de processos (não confundir com os processos do sistema operacional da máquina local). Esses processos são supervisionados pela própria BEAM, para que quando haja algum erro, o sistema se recupere sozinho e sem atrapalhar os outros processos.

Quando uma aplição Elixir/Erlang é iniciada, a BEAM cria um "Agendador" (Scheduler) para cada núcleo da CPU da máquina. Esses Agendadores também são processos, mas que supervisionam, agendam e gerenciam os outros processos da aplicação. A imagem a seguir exemplifica a crição dos Agendadores:

<p align="center">
  <img src="https://user-images.githubusercontent.com/44469426/230241258-08aeb6d8-9038-4eda-89f0-fb13de077aa9.png" />
</p>

[beam-meaning]: https://www.erlang.org/blog/a-brief-beam-primer/
[erlang-meaning]: https://coodesh.com/blog/dicionario/o-que-e-erlang/
[immutability]: https://medium.com/opensanca/imutabilidade-eis-a-quest%C3%A3o-507fde8c6686
[imperative-prog]: https://pt.wikipedia.org/wiki/Programa%C3%A7%C3%A3o_imperativa
[functional-prog]: https://pt.wikipedia.org/wiki/Programa%C3%A7%C3%A3o_funcional
[java-meaning]: https://www.java.com/pt-BR/download/help/whatis_java.html
[jvm-meaning]: https://pt.wikipedia.org/wiki/M%C3%A1quina_virtual_Java
[prolog-meaning]: https://ww2.inf.ufg.br/~eduardo/lp/alunos/prolog/prolog.html
[thread-meaning]: https://pt.wikipedia.org/wiki/Thread_(computa%C3%A7%C3%A3o)
[oop-meaning]: https://www.alura.com.br/artigos/poo-programacao-orientada-a-objetos
[process-meaning]: https://pt.wikipedia.org/wiki/Processo_(inform%C3%A1tica)
[cpu-meaning]: https://pt.wikipedia.org/wiki/Unidade_central_de_processamento
[paralel-meaning]: https://pt.wikipedia.org/wiki/Computa%C3%A7%C3%A3o_paralela
[concurrency-meaning]: (https://pt.wikipedia.org/wiki/Programa%C3%A7%C3%A3o_concorrente)
[elixir-site]: https://elixir-lang.org
