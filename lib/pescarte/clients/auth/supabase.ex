defmodule Pescarte.Clients.Auth.Supabase do
  use PescarteWeb, :verified_routes
  alias Supabase.GoTrue
  alias Supabase.GoTrue.Session
  alias Supabase.GoTrue.Admin

  @behaviour Pescarte.Clients.Auth.Behaviour

  @client Application.compile_env!(:supabase_gotrue, :authentication_client)

  @impl true
  def create_user(%{} = params) do
    with {:ok, user} <- Admin.create_user(@client, params),
         opts = [type: :signup, redirect_to: ~p"/confirmar"],
         :ok <- GoTrue.resend(:pescarte_supabase, params.email, opts) do
      {:ok, user}
    end
  end

  @impl true
  def update_user(id, %{} = params) do
    Admin.update_user_by_id(@client, id, params)
  end

  @impl true
  def delete_user(id) do
    Admin.delete_user(@client, id, should_soft_delete: true)
  end

  @impl true
  def get_user(id) do
    Admin.get_user_by_id(@client, id)
  end

  @impl true
  def authenticate(%{email: _, password: _} = params) do
    with {:ok, session} <- GoTrue.sign_in_with_password(@client, params),
    :ok <- Supabase.Client.update_access_token(@client, session.access_token) do
      {:ok, session}
    end
  end

  @impl true
  def sign_out(token, scope) do
  	Admin.sign_out(@client, %Session{access_token: token}, scope)
  end

  @impl true
  def resend_confirmation_email(email, type, redirect_to) do
  	opts = [type: type, redirect_to: redirect_to]
  	GoTrue.resend(@client, email, opts)
  end
end
