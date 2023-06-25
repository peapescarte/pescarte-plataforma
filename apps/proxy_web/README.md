# Proxy Web

Uma aplicação para redirecionar requisições web para diferentes aplicações internas. Dessa forma é possível subir apenas um servidor web, que responde em diferentes rotas ou domínios, de forma prática e escalável.

## Como usar

Para subir o servidor web, basta executar `mix phx.server` dentro da raiz do projeto Pescarte, ou caso queira uma REPL interativo: `iex -S mix phx.server`.

Caso seja necessário definir uma nova aplicação que irá receber requisições web, vá para o arquivo de [Endpoint](./lib/proxy_web/endpoint.ex), adicione sua aplicação no mapa de redirecionamento.
Após essa adição, vá para o arquivo de [Router](./lib/proxy_web/plugs/router.ex) e defina a lógica necessária para o redirecionamento das requisições.

Atualmente o redirecionamento ocorre com base no caminho de rotas das chamadas. Essa lógica pode ser modificada ou extendida caso necessária. Dessa forma, atualmente existem duas aplicações que recebem o redirecionamento:
1. [Plataforma Digital](../plataforma_digital): Recebe toda requisição, por padrão.
2. [API Plataforma Digital](../plataforma_digital_api): Recebe requisições a partir do caminho de rota `/api`.
