defmodule PescarteWeb.ErrorHTML do
  use PescarteWeb, :html

#  embed_templates "error_html/*"

  # The default is to render a plain text page based on
  # the template name. For example, "404.html" becomes
  # "Not Found".
  # def render(template, _assigns) do
  #  Phoenix.Controller.status_message_from_template(template)
  #end

   def render("404.html", _assigns) do
    ~L"""
    <div class="container">
      <section class="phx-hero">
        <p>OOPS, Página não existe</p>
      </section>
      <img src="/priv/static/images/404.svg" alt="erro404" class="top-banner" />
      <a href=" " class="phx-hero">
        <img src="/priv/static/images/404.svg" alt="erro404"/>
      </a>
    </div>
    """
##    "OOPS !!!! Error, página não encontrada"
#    Phoenix.Controller.status_message_from_template("404.html")
#     Phoenix.Controller.render_layout PescarteWeb.LayoutView, "app.html", _assigns do
#      render("404.html", _assigns)
#     end
   end
end
