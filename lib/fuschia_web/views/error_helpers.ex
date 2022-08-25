defmodule FuschiaWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """
  use Phoenix.HTML

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    if error = form.errors[field] do
      content_tag(:span, translate_error(error), class: "help-block")
    end
  end

  @doc """
  Translates an error message using gettext.
  """
  @spec translate_error(map) :: binary
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(FuschiaWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(FuschiaWeb.Gettext, "errors", msg, opts)
    end
  end
end
