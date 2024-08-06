defmodule PescarteWeb.LandingHTML do
  use PescarteWeb, :html

  embed_templates("landing_html/*")

  def handle_notice_text_length(text, max_length) do
    case String.length(text) do
    text_length when (text_length >= max_length) ->
    String.slice(text, 0..max_length - 4) <> "..."
    _text_length -> text
    end
  end
end
