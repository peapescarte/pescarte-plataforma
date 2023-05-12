defmodule PescarteWeb.ErrorHTML do
  use PescarteWeb, :html

  embed_templates "error_html/*"

  # The default is to render a plain text page based on
  # the template name. For example, "404.html" becomes
  # "Not Found".
  # def render(template, _assigns) do
  #  Phoenix.Controller.status_message_from_template(template)
  #end

#   def render("404.html", _assigns) do
##    "OOPS !!!! Error, página não encontrada"
#    Phoenix.Controller.status_message_from_template("404.html")
#   end
end
