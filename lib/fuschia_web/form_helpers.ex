defmodule FuschiaWeb.FormHelpers do
  @moduledoc false

  use Phoenix.HTML

  import FuschiaWeb.ErrorHelpers, only: [error_tag: 2]
  import Phoenix.HTML.Form, only: [input_type: 2, input_validations: 2]

  @input_base_style ~s(input bg-white)

  def input(form, field, opts \\ []) do
    type = opts[:using] || input_type(form, field)
    validations = input_validations(form, field)
    extra_classes = opts[:class]

    extra_wrapper_classes = opts[:wrapper_class] || ""
    wrapper_opts = [class: "form-control " <> extra_wrapper_classes]

    input_style =
      @input_base_style
      |> Kernel.<>(" ")
      |> Kernel.<>(state_class(form, field))
      |> Kernel.<>(" ")
      |> Kernel.<>(extra_classes || "")

    input_opts = Keyword.merge(validations, class: input_style, placeholder: opts[:placeholder])

    content_tag :fieldset, wrapper_opts do
      input = input(type, form, field, input_opts)
      error = error_tag(form, field)

      [input, error || ""]
    end
  end

  defp state_class(form, field) do
    if form.errors[field] do
      "input-error"
    else
      ""
    end
  end

  defp input(type, form, field, input_opts) do
    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end
end
