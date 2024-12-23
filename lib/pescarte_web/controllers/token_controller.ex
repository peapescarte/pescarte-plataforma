defmodule PescarteWeb.TokenController do
  use PescarteWeb, :controller

  import Phoenix.LiveView.Controller, only: [live_render: 2]

  alias PescarteWeb.Auth
  alias PescarteWeb.LoginLive
  alias Supabase.GoTrue

  require Logger

  @cannot_confirm_err "Não foi possível confirmar seu cadastro, contate o suporte"
  @cannot_reset_err "Você não possui permissão para acessar essa página"

  def confirm(conn, %{"token_hash" => token, "type" => "signup"}) do
    with {:ok, client} <- Pescarte.get_supabase_client(),
         params = %{token_hash: token, type: :signup},
         {:ok, session} <- GoTrue.verify_otp(client, params),
         {:ok, _} <- GoTrue.get_user(client, session) do
      conn
      |> Auth.put_token_in_session(session.access_token)
      |> redirect(to: ~p"/app/pesquisa/perfil?type=recovery")
    else
      {:error, %{"error_code" => "otp_expired"}} ->
        Logger.error("[#{__MODULE__}] ==> Token de confirmação de cadastro expirado!")

        conn
        |> put_flash(:error, "Parece que o código de verificação informado expirou")
        |> put_layout(false)
        |> live_render(LoginLive)

      {:error, err} ->
        Logger.error("""
        [#{__MODULE__}] ==> Não foi possível validar o token de confirmação de cadastro
        ERROR: #{inspect(err, pretty: true)}
        """)

        conn
        |> put_flash(:error, @cannot_confirm_err)
        |> put_layout(false)
        |> live_render(LoginLive)
    end
  end

  def confirm(conn, %{"token_hash" => token, "type" => "recovery"}) do
    with {:ok, client} <- Pescarte.get_supabase_client(),
         params = %{token_hash: token, type: :recovery},
         {:ok, session} <- GoTrue.verify_otp(client, params),
         {:ok, _} <- GoTrue.get_user(client, session) do
      conn
      |> Auth.put_token_in_session(session.access_token)
      |> redirect(to: ~p"/app/pesquisa/perfil?type=recovery")
    else
      {:error, %{"error_code" => "otp_expired"}} ->
        Logger.error("[#{__MODULE__}] ==> Token de recuperação de senha expirado!")

        conn
        |> put_flash(:error, "Parece que o código de verificação informado expirou")
        |> put_layout(false)
        |> live_render(LoginLive)

      {:error, err} ->
        Logger.error("""
        [#{__MODULE__}] ==> Não foi possível validar o token de recuperação de senha
        ERROR: #{inspect(err, pretty: true)}
        """)

        conn
        |> put_flash(:error, @cannot_reset_err)
        |> put_layout(false)
        |> live_render(LoginLive)
    end
  end

  def confirm(conn, _) do
    Logger.error("[#{__MODULE__}] ==> Requisição de confirmação de token com parâmetros errados")

    conn
    |> put_flash(:error, "Parece que seu código de confirmação é inválido")
    |> put_layout(false)
    |> live_render(LoginLive)
  end
end
