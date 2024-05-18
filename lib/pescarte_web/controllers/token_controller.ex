defmodule PescarteWeb.TokenController do
  use PescarteWeb, :controller

  import Phoenix.LiveView.Controller, only: [live_render: 2]

  alias Pescarte.Supabase.Auth
  alias PescarteWeb.LoginLive
  alias Supabase.GoTrue

  require Logger

  @cannot_confirm_err "Não foi possível confirmar seu cadastro, contate o suporte"
  @cannot_reset_err "Você não possui permissão para acessar essa página"

  def confirm(conn, %{"token_hash" => token, "type" => "confirm"}) do
    with {:ok, session} <- Auth.verify_otp(%{token_hash: token, type: :recovery}),
         {:ok, _} <- Auth.get_user(session) do
      conn
      |> GoTrue.Plug.put_token_in_session(session.access_token)
      |> redirect(to: ~p"/app/pesquisa/perfil?type=recovery")
    else
      {:error, %{"error_code" => "otp_expired"}} ->
        conn
        |> put_flash(:error, "Parece que o código de verificação informado expirou")
        |> put_layout(false)
        |> live_render(LoginLive)

      {:error, _} ->
        conn
        |> put_flash(:error, @cannot_confirm_err)
        |> put_layout(false)
        |> live_render(LoginLive)
    end
  end

  def confirm(conn, %{"token_hash" => token, "type" => "recovery"}) do
    with {:ok, session} <- Auth.verify_otp(%{token_hash: token, type: :recovery}),
         {:ok, _} <- Auth.get_user(session) do
      conn
      |> GoTrue.Plug.put_token_in_session(session.access_token)
      |> redirect(to: ~p"/app/pesquisa/perfil?type=recovery")
    else
      {:error, %{"error_code" => "otp_expired"}} ->
        conn
        |> put_flash(:error, "Parece que o código de verificação informado expirou")
        |> put_layout(false)
        |> live_render(LoginLive)

      {:error, _} ->
        conn
        |> put_flash(:error, @cannot_reset_err)
        |> put_layout(false)
        |> live_render(LoginLive)
    end
  end

  def confirm(conn, _) do
    conn
    |> put_flash(:error, "Parece que seu código de confirmação é inválido")
    |> put_layout(false)
    |> live_render(LoginLive)
  end
end
