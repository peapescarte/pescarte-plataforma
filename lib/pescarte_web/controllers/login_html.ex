defmodule PescarteWeb.LoginHTML do
  use PescarteWeb, :html

  def new(assigns) do
    ~H"""
    <.simple_form :let={f} for={@conn} action={~p"/acessar"} id="login_form">
      <.input field={{f, :cpf}} label="CPF" id="user_cpf" error?={!!@error} />
      <.input field={{f, :password}} label="Senha" type="password" error?={!!@error} />

      <.error :if={@error}>
        <%= @error %>
      </.error>

      <:actions>
        <.button type="submit" style="primary">
          Acessar
        </.button>
      </:actions>
    </.simple_form>
    """
  end
end
