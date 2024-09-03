defmodule PescarteWeb.LandingHTML do
  use PescarteWeb, :html

  embed_templates("landing_html/*")

  @notice_title_max_length Application.compile_env!(:pescarte, [
                             PescarteWeb,
                             :notice_title_max_length
                           ])

  @notice_desc_max_length Application.compile_env!(:pescarte, [
                            PescarteWeb,
                            :notice_desc_max_length
                          ])

  def handle_notice_title_length(text) do
    if String.length(text) > @notice_title_max_length do
      text
      |> truncate_text_until(@notice_title_max_length - 4)
      |> put_ellipsis()
    else
      text
    end
  end

  def handle_notice_desc_length(text) do
    if String.length(text) > @notice_desc_max_length do
      text
      |> truncate_text_until(@notice_desc_max_length - 4)
      |> put_ellipsis()
    else
      text
    end
  end

  defp truncate_text_until(text, length) do
    text
    |> String.slice(0..length)
    |> String.trim_trailing()
  end

  defp put_ellipsis(text) do
    text <> "..."
  end
end
