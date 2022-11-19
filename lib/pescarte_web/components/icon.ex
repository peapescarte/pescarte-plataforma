defmodule PescarteWeb.Components.Icon do
  @moduledoc """
  Componente de ícones reutilizável e dinâmico
  """

  use PescarteWeb, :component

  alias PescarteWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~H"""
    <figure>
      <img
        role="img"
        src={build_icon_path(@name)}
        alt={get_alt_text(@name)}
        class={["icon", "icon-#{@name}"]}
      />
    </figure>
    """
  end

  def build_icon_path(icon_name) do
    Routes.static_path(PescarteWeb.Endpoint, "/icons/#{icon_name}.svg")
  end

  def get_alt_text("accounts") do
    "Ícone que representa duas ou mais contas"
  end

  def get_alt_text("agenda") do
    "Ícone que representa um calendário"
  end

  def get_alt_text("book") do
    "Ícone que representa um livro aberto"
  end

  def get_alt_text("compilation") do
    "Ícone que representa uma compilação de arquivos"
  end

  def get_alt_text("file") do
    "Ícone que representa um arquivo"
  end

  def get_alt_text("filter") do
    "Ícone que representa um filtro"
  end

  def get_alt_text("home") do
    "Ícone que representa uma casa"
  end

  def get_alt_text("image") do
    "Ícone que representa uma imagem"
  end

  def get_alt_text("login") do
    "Ícone que representa uma seta para entrada"
  end

  def get_alt_text("message") do
    "Ícone que representa uma mensagem"
  end

  def get_alt_text("new_account") do
    "Ícone que representa uma nova conta a ser criada"
  end

  def get_alt_text("new_file") do
    "Ícone que representa um novo arquivo a ser criado"
  end

  def get_alt_text("search") do
    "Ícone que representa uma lupa para pesquisa"
  end

  def get_alt_text("edit_profile") do
    "Ícone que representa a edição do perfil"
  end

  def get_alt_text("points") do
    "Ícone que representa o menu de edição no perfil"
  end

  def get_alt_text("password") do
    "Ícone que representa a troca de password"
  end

  def get_alt_text("lattes") do
    "Ícone que representa o curriculo lattes"
  end

  def get_alt_text("linkedin") do
    "Ícone que representa o linkedin"
  end
end
