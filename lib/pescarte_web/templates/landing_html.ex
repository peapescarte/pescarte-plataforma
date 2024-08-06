defmodule PescarteWeb.LandingHTML do
  use PescarteWeb, :html

  embed_templates("landing_html/*")

  def handle_notice_text_length(text, max_length) do
    case String.length(text) do
      text_length when text_length >= max_length ->
        text =
          text
          |> String.slice(0..(max_length - 4))
          |> String.trim_trailing()

        text <> "..."

      _text_length ->
        text
    end
  end
end
