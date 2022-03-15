defmodule FuschiaWeb.UserAuth do
  @moduledoc """
  Funções do contexto de autenticação de usuários
  via browser. Apenas Funções puras.
  """

  import FuschiaWeb.Gettext
  import Plug.Conn
  import Phoenix.Controller

  alias Fuschia.Accounts
  alias Fuschia.Accounts.Models.UserModel
  alias FuschiaWeb.Router.Helpers, as: Routes

  # Faça o cookie lembrar do usuário ser válido por 60 dias.
  # Se você quiser aumentar ou reduzir esse valor, altere também
  # a própria expiração do token em UserToken.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_fuschia_web_user_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  @doc """
  Define para qual rota o usuário será
  redirecionado após o login
  """
  def signed_in_path(conn) do
    if user = Map.get(conn.assigns, :current_user) do
      # TODO
      # change to Routes.user_*/* function
      "/app/pesquisadores/#{user.id}"
    else
      with user_token when is_binary(user_token) <- get_session(conn, :user_token),
           %UserModel{id: user_id} <- Accounts.get_user_by_session_token(user_token) do
        "/app/pesquisadores/#{user_id}"
      else
        _e -> "/not_found"
      end
    end
  end

  @doc """
  Faz o login do usuário.

  Renova o ID da sessão e limpa toda a sessão
  para evitar ataques de fixação. Veja a renovação_sessão
  função para personalizar esse comportamento.

  Ele também define uma chave `:live_socket_id` na sessão,
  para que as sessões do LiveView sejam identificadas e automaticamente
  desconectado no logout.
  """
  def log_in_user(conn, user, params \\ %{}) do
    token = Accounts.generate_user_session_token(user)
    user_return_to = get_session(conn, :user_return_to)

    conn
    |> renew_session()
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "user_sessions:#{Base.url_encode64(token)}")
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: user_return_to || signed_in_path(conn))
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  # Esta função renova o ID da sessão e apaga todo o
  # sessão para evitar ataques de fixação. Se houver algum dado
  # na sessão que você deseja preservar após o login/logout,
  # você deve buscar explicitamente os dados da sessão antes de limpar
  # e, em seguida, defina-o imediatamente após a limpeza, por exemplo:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Desconecta o usuário.

  Ele limpa todos os dados da sessão por segurança. Consulte renovação_sessão.
  """
  def log_out_user(conn) do
    user_token = get_session(conn, :user_token)
    user_token && Accounts.delete_session_token(user_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      FuschiaWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: "/")
  end

  @doc """
  Autentica o usuário olhando para a sessão e lembre-se do token do usuário.
  """
  def fetch_current_user(conn, _opts) do
    {user_token, conn} = ensure_user_token(conn)
    user = user_token && Accounts.get_user_by_session_token(user_token)
    assign(conn, :current_user, user)
  end

  defp ensure_user_token(conn) do
    if user_token = get_session(conn, :user_token) do
      {user_token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if user_token = conn.cookies[@remember_me_cookie] do
        {user_token, put_session(conn, :user_token, user_token)}
      else
        {nil, conn}
      end
    end
  end

  @doc """
  Usado para rotas que exigem que o usuário não seja autenticado.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Usado para rotas que exigem que o usuário seja autenticado.

  Se você deseja impor que o e-mail do usuário esteja confirmado antes
  deles usam o aplicativo, aqui seria um bom lugar.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, dgettext("erros", "You must log in to access this page."))
      |> maybe_store_return_to()
      |> redirect(to: Routes.user_session_path(conn, :new))
      |> halt()
    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn
end
