# Testes de Integração

Utilizamos as funçÕes nativas do `ExUnit` a fim de ter o benefício de
rodar os testes de integração/aceitação como parte da suíte de testes total.

Além disso, seguimos como referência a estratégia implementada pelo [Hex](https://github.com/hexpm/hexpm/tree/main/test)

Em suma, testamos o comportamento, não a implementação.

## Exemplo

Vamos supor que temos ações de um usuário e precisamos integrar com uma API externa.
Essa API precisa de autenticação via token.

Criamos um módulo com funções de ajuda para acessar essa API:
```elixir
defmodule Fuschia.TestHelpers.ExternalApi do
  @moduledoc """
  Funções de ajuda para interagir com a API externa.
  """

  alias Plug.Conn
  alias Phoenix.ConnTest
  require Phoenix.ConnTest

  # Endpoint padrão
  @endpoint MyApp.Endpoint

  def get(url, api_key \\ nil) do
    %{status: status, resp_body: body} =
      api_key
      |> build_conn()
      |> ConnTest.get(url)

    %{status: status, body: if(body != "", do: Jason.decode!(body), else: "")}
  end

  defp build_conn(api_key) do
    conn =
      ConnTest.build_conn()
      |> Conn.put_req_header("accept", "application/json")

    if api_key do
      conn |> Conn.put_req_header("authorization", "Bearer #{api_key}")
    else
      conn
    end
  end
end
```

Caso seja necessário, podemos criar um módulo `UserUI`, no qual implementaria
funções que realizam as ações do usuário. Uma alternativa a isso é inserir os dados
diretamente por meio de `factories`.

Já no teste em si:
```elixir
defmodule Fuschia.ExternalApiTest do
  use Fuschia.ConnCase, async: true

  alias Fuschia.TestHelpers.UserUI
  alias Fuschia.TestHelpers.ExternalApi

  @moduletag :integration

  describe "GET /api/actions" do
    test "lists actions made by a user" do
      # Setup...
      account = UserUI.create_account!()
      message = UserUI.create_message!(account)
      # More setup...

      assert ExternalApi.get("/api/actions", api_key) == %{
               status: 200,
               body: %{
                 "actions" => [
                   %{
                     "id" => 1,
                     "subject" => message2.subject,
                     "sent_at" => DateTime.to_iso8601(message2.inserted_at)
                   },
                   %{
                     "id" => 2,
                     "subject" => message1.subject,
                     "sent_at" => DateTime.to_iso8601(message1.inserted_at)
                   }
                 ]
               }
             }
    end

    test "returns 401 on expired API key" do
      # Setup...

      assert %{
               status: 401,
               body: %{"error" => "expired_api_key"}
             } = ExternalApi.get("/api/actions", api_key)
    end
  end
end
```

## Mox

Em alguns casos será necessário criar mocks de APIs externas, para isso usamos a lib [Mox](https://github.com/dashbitco/mox)

Para mais informações, leia o `README` da biblioteca: https://github.com/dashbitco/mox

Além do exemplo implementado no [Hex](https://github.com/hexpm/hexpm/blob/main/test/hexpm_web/controllers/api/organization_controller_test.exs)

## Referências

- https://dashbit.co/blog/mocks-and-explicit-contracts
- https://elixirforum.com/t/how-do-you-implement-integration-tests-for-a-phoenix-api
