defmodule PlataformaDigital.ErrorHTML do
  use PlataformaDigital, :html

  embed_templates "error_html/*"

  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
