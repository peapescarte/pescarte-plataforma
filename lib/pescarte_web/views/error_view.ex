defmodule BackendWeb.ErrorView do
  use BackendWeb, :view

  @spec translate_errors(Ecto.Changeset.t()) :: list(map)
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("500.html", _assigns) do
    "Erro do servidor"
  end

  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
