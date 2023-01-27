defmodule PescarteWeb.UserAuthentication do
  @moduledoc """
  Funções do contexto de autenticação de usuários
  via browser. Apenas Funções puras.
  """

  use PescarteWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  alias Pescarte.Domains.Accounts

  # Faça o cookie lembrar do usuário ser válido por 60 dias.
  # Se você quiser aumentar ou reduzir esse valor, altere também
  # a própria expiração do token em UserToken.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_pescarte_web_user_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  @doc """
  Define para qual rota o usuário será
  redirecionado após o login
  """
  def signed_in_path do
    ~p"/app/perfil"
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
    |> put_token_in_session(token)
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: user_return_to || signed_in_path())
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
      PescarteWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: ~p"/")
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
        {user_token, put_token_in_session(conn, user_token)}
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
      |> redirect(to: signed_in_path())
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
      |> put_flash(:error, "You must log in to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: ~p"/acessar")
      |> halt()
    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  @doc """
  Handles mounting and authenticating the current_user in LiveViews.

  ## `on_mount` arguments

    * `:mount_current_user` - Assigns current_user
      to socket assigns based on user_token, or nil if
      there's no user_token or no matching user.

    * `:ensure_authenticated` - Authenticates the user from the session,
      and assigns the current_user to socket assigns based
      on user_token.
      Redirects to login page if there's no logged user.

    * `:redirect_if_user_is_authenticated` - Authenticates the user from the session.
      Redirects to signed_in_path if there's a logged user.

  ## Examples

  Use the `on_mount` lifecycle macro in LiveViews to mount or authenticate
  the current_user:

      defmodule PescarteWeb.PageLive do
        use PescarteWeb, :live_view

        on_mount {PescarteWeb.UserAuth, :mount_current_user}
        ...
      end

  Or use the `live_session` of your router to invoke the on_mount callback:

      live_session :authenticated, on_mount: [{PescarteWeb.UserAuth, :ensure_authenticated}] do
        live "/profile", ProfileLive, :index
      end
  """
  def on_mount(:mount_current_user, _params, session, socket) do
    {:cont, mount_current_user(session, socket)}
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    socket = mount_current_user(session, socket)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(
          :error,
          "Você precisa estar logado para acessar esta página"
        )
        |> Phoenix.LiveView.redirect(to: ~p"/acessar")

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_user_is_authenticated, _params, session, socket) do
    socket = mount_current_user(session, socket)

    if socket.assigns.current_user do
      {:halt, Phoenix.LiveView.redirect(socket, to: signed_in_path())}
    else
      {:cont, socket}
    end
  end

  def mount_current_user(session, socket) do
    case session do
      %{"user_token" => user_token} ->
        Phoenix.Component.assign_new(socket, :current_user, fn ->
          Accounts.get_user_by_session_token(user_token)
        end)

      %{} ->
        Phoenix.Component.assign_new(socket, :current_user, fn -> nil end)
    end
  end

  defp put_token_in_session(conn, token) do
    conn
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
  end
end
