defmodule PescarteWeb.FormHelpers do
  @moduledoc false

  use Phoenix.HTML

  import PescarteWeb.ErrorHelpers, only: [error_tag: 2]
  import Phoenix.HTML.Form, only: [input_type: 2, input_validations: 2, humanize: 1, label: 3]

  @input_base_style ~s(input bg-white)

  def input(form, field, opts \\ []) do
    label = opts[:label]

    type = opts[:type] || input_type(form, field)
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

    input_opts =
      validations
      |> Keyword.put(:class, input_style)
      |> Keyword.put(:readonly, opts[:readonly?])
      |> Keyword.merge(opts)

    content_tag :fieldset, wrapper_opts do
      input = input(type, form, field, input_opts)
      error = error_tag(form, field)

      if label do
        label = label(form, field, humanize(label || field))
        [label, input, error || ""]
      else
        [input, error || ""]
      end
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
