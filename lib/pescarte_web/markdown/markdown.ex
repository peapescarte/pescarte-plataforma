defmodule PescarteWeb.Markdown do
  @moduledoc """
  Módulo responsável por converter markdown para HTML.
  """

  alias Earmark

  def to_html(markdown) do
    Earmark.as_html!(markdown)
  end
end
