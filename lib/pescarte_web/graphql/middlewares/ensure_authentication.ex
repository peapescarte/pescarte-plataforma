defmodule PescarteWeb.GraphQL.Middlewares.EnsureAuthentication do
  @behaviour Absinthe.Middleware

  import Absinthe.Resolution, only: [path: 1, put_result: 2]

  @error_message "Usuário não autenticado ou token expirado"

  def call(resolution, _) do
    path = Enum.filter(path(resolution), &(&1 == "login"))

    case {resolution.context, path} do
      {_ctx, ["login"]} ->
        resolution

      {%{current_user: _}, _path} ->
        # implementar autorização
        resolution

      {_ctx, _path} ->
        put_result(resolution, {:error, message: @error_message, code: 401})
    end
  end
end
