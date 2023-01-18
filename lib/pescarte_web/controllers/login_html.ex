defmodule PescarteWeb.LoginHTML do
  use PescarteWeb, :html

  embed_templates "login_html/*"

  def background_img(assigns) do
    ~H"""
    <img
      src={~p"/images/fish_background.svg"}
      class="absolute -z-50 h-screen w-screen top-10 bg-transparent"
    />
    """
  end

  def new(assigns) do
    ~H"""
    <section>
      <.background_img />
      <.simple_form :let={f} for={@conn} action={~p"/acessar"} id="login_form">
        <.error :if={@error}>
          <%= @error %>
        </.error>
        <.input field={{f, :cpf}} label="cpf" id="user_cpf" />
        <.input field={{f, :password}} label="password" type="password" />

        <:actions>
          <.button type="submit" style="primary">
            Acessar
          </.button>
        </:actions>
      </.simple_form>
    </section>
    """
  end
end
