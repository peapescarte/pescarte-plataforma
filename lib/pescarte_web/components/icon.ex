defmodule PescarteWeb.Components.Icon do
  @moduledoc """
  Componente de ícones reutilizável e dinâmico
  """

  use PescarteWeb, :component

  alias PescarteWeb.Router.Helpers, as: Routes

  @icons_path "/icons/"

  def render(assigns) do
    ~H"""
    <figure>
      <img src={build_icon_path(@name)} alt={get_alt_text(@name)} class={assigns[:class] || ""} />
    </figure>
    """
  end

  def build_icon_path(icon_name) do
    path = @icons_path <> Atom.to_string(icon_name) <> ".svg"
    Routes.static_path(PescarteWeb.Endpoint, path)
  end

  def get_alt_text(:attachment) do
    "Ícone de anexo"
  end

  def get_alt_text(:bell) do
    "Ícone de sino, que representa as notificações"
  end

  def get_alt_text(:download) do
    "Ícone de download"
  end

  def get_alt_text(:dropdown) do
    "Ícone de botão dropdown"
  end

  def get_alt_text(:edit_profile) do
    "Ícone para edição das informações de perfil"
  end

  def get_alt_text(:edit) do
    "Ícone para itens editáveis"
  end

  def get_alt_text(:loading) do
    "Ícone de carregamento"
  end

  def get_alt_text(:lock) do
    "Ícone de cadeado"
  end

  def get_alt_text(:merge) do
    "Ícone que representa mesclagem"
  end

  def get_alt_text(:seen_eye) do
    "Ícone que representa uma notificação visualizada"
  end

  def get_alt_text(:trashcan) do
    "Ícone de lixeira"
  end

  def get_alt_text(:upload) do
    "Ícone que representa um upload"
  end

  def get_alt_text(:user) do
    "Ícone padrão para foto de perfil/avatar"
  end

  def get_alt_text(:white_check) do
    "Ícone de um check branco"
  end
end
