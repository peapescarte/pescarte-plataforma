defmodule PescarteWeb.LoginHTML do
  use PescarteWeb, :html

  embed_templates "login_html/*"

  def background_img(assigns) do
    ~H"""
    <img src={~p"/images/fish_background.svg"} class="absolute -z-50 h-screen w-screen top-10" />
    """
  end

  def new(assigns) do
    ~H"""
    <.simple_form :let={f} for={@conn} as={:user} action={~p"/acessar"}>
      <.input field={{f, :cpf}} label="cpf" />
      <.input field={{f, :password}} label="password" />

      <:actions>
        <%= submit("acessar") %>
      </:actions>
    </.simple_form>
    """
  end
end
