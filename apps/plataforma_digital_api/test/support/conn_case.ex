defmodule PlataformaDigitalAPI.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use PlataformaDigitalAPI.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import PlataformaDigitalAPI.ConnCase

      # The default endpoint for testing
      @endpoint PlataformaDigitalAPI.Endpoint
    end
  end

  setup tags do
    pid = Sandbox.start_owner!(Database.EscritaRepo, shared: not tags[:async])
    on_exit(fn -> Sandbox.stop_owner(pid) end)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end


  @token_salt "autenticação de usuário"

  @doc """
  Insere e cria um JWT para um usuário, para ser usado nos testes
  de API.

      setup :register_and_generate_jwt_token

  Atente-se pois essa função adiciona um header na `conn`
  """
  def register_and_generate_jwt_token(%{conn: conn}) do
    user = Identidades.Factory.insert(:usuario)
    token = Phoenix.Token.sign(PlataformaDigitalAPI.Endpoint, @token_salt, user.id_publico)
    %{conn: Plug.Conn.put_req_header(conn, "authorization", "Bearer " <> token), user: user}
  end
end
