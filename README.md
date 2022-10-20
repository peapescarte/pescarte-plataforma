```{=org}
#+caption: CI
```
<https://github.com/cciuenf/pescarte/workflows/elixir_ci/badge.svg?branch=dev>

Plataforma Digital PEA Pescarte

------------------------------------------------------------------------

## Setup

### GitHub Packages

Antes de subir o ambiente com Docker, é necessário autenticar-se no
GitHub Packages. Crie um token acessando as [configurações do seu perfil
GitHub](https://github.com/settings/profile) \> Developer Settings \>
Personal Access Tokens. Para saber quais são as permissões necessárias
para o token, leia a
[documentação](https://docs.github.com/pt/packages/learn-github-packages/about-permissions-for-github-packages)
sobre o GitHub Packages.

Após criar o token, já é possível fazer a autenticação no GitHub
Packages:

``` {.bash org-language="sh"}
echo "<personal_token>" | docker login ghcr.io -u USERNAME --password-stdin
```

## Ambiente de desenvolvimento

### Primeira vez rodando

1.  Varáveis de ambiente

    Copie o arquivo [.env-sample](./.env-sample) para um novo arquivo
    `.env`{.verbatim} e defina os valores necessários nas variáveis de
    ambiente.

2.  Ferramentas para ambiente local

    Este projeto possui três opções para ambientes de desenvolvimento:

    1.  [Docker](./guides/local/docker.md)
    2.  [Nix](./guides/local/nix.md)
    3.  [asdf](./guides/local/asdf.md)

    ------------------------------------------------------------------------

## Guias

-   [Testes](./guiides/tests.md)
-   [Testes de integração](./guides/integration_tests.md)

------------------------------------------------------------------------

## Aplicações

Esse projeto está dividio em diversas sub-aplicações que possuem
diferentes responsabilidades.

``` example
# TODO
```

### Pescarte.Mailer

Responsável pelo processamento e envio/disparo dos emails. Estamos
utilizando o [Swoosh](https://github.com/swoosh/swoosh).

Para testar o preview de email, siga a seguinte documentação:

1.  Variáveis de ambiente

    Necessárias em produção:

    -   `MAIL_SERVER`{.verbatim}: Server do smtp (default:
        `smtp.gmail.com`{.verbatim})
    -   `MAIL_USERNAME`{.verbatim}: User do smtp (default:
        `notificacoes-noreply@peapescarte.uenf.br`{.verbatim})
    -   `MAIL_PASSWORD`{.verbatim}: Senha do smtp
    -   `MAIL_PORT`{.verbatim}: Porta do smtp (default:
        `587`{.verbatim})
    -   `MAIL_SERVICE`{.verbatim}: O serviço de email a ser usado. Pode
        ser `gmail`{.verbatim} ou `local`{.verbatim}. (default prod:
        `gmail`{.verbatim}, default dev: `local`{.verbatim})

    **Observação**: Em ambiente de desenvolvimento, toda vez que a
    variável de ambiente `MAIL_SERVICE`{.verbatim} é alterada para
    trocar o adapter, toda a aplicação deve ser compilada usando

    ``` {.bash org-language="sh"}
    mix compile --force
    ```

2.  Rodando localmente

    Essa aplicação também conta com um servidor para visualizar os
    emails enviados usando o adaptador local, basta entrar na
    aplicação/container e utilizar:

    ``` {.bash org-language="sh"}
    iex -S mix swoosh.mailbox.server
    ```

    E um servidor no local <http://127.0.0.1:4001> vai apresentar uma
    página web listando os emails enviados localmente através do
    `iex`{.verbatim} que ficou aberto com o comando anterior.

    Caso esteja rodando o servidor com o comando
    `iex -S mix phx.server`{.verbatim}, a caixa de entrada também poderá
    ser acessada no endereço <http://127.0.0.1/dev/maibox>.

    ------------------------------------------------------------------------

## Materiais, Tutoriais, Relatórios e extras

Todo o material do projeto (tanto backend ou frontend) pode ser
encontrado no repositório
[documentos~peapescarte~](https://github.com/cciuenf/documentos_pea_pescarte),
que abriga diversos artigos.
