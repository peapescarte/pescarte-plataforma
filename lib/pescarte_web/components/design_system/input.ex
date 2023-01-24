defmodule PescarteWeb.DesignSystem.Input do
  @moduledoc """
  Renders an input with label and error messages.

  A `%Phoenix.HTML.Form{}` and field name may be passed to the input
  to build input names and error messages, or all the attributes and
  errors may be passed explicitly.

  ## Examples

      <.input field={{f, :email}} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """

  use Phoenix.Component

  attr :id, :any
  attr :name, :any
  attr :label, :string, default: nil
  attr :success?, :boolean, default: false
  attr :error?, :boolean, default: false

  attr :type, :string,
    default: "text",
    values: ~w(checkbox date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)

  attr :value, :any
  attr :field, :any, doc: "a %Phoenix.HTML.Form{}/field name tuple, for example: {f, :email}"
  attr :errors, :list
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :rest, :global, include: ~w(autocomplete cols disabled form max maxlength min minlength
                                   pattern placeholder readonly required rows size step)
  slot :inner_block

  def input(%{field: {f, field}} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:name, fn ->
      name = Phoenix.HTML.Form.input_name(f, field)
      if assigns.multiple, do: name <> "[]", else: name
    end)
    |> assign_new(:id, fn -> Phoenix.HTML.Form.input_id(f, field) end)
    |> assign_new(:value, fn -> Phoenix.HTML.Form.input_value(f, field) end)
    |> assign_new(:errors, fn -> f.errors || [] end)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    assigns = assign_new(assigns, :checked, fn -> input_equals?(assigns.value, "true") end)

    ~H"""
    <label phx-feedback-for={@name} class="">
      <input type="hidden" name={@name} value="false" />
      <input
        type="checkbox"
        id={@id || @name}
        name={@name}
        value="true"
        checked={@checked}
        class=""
        {@rest}
      />
      <%= @label %>
    </label>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <select id={@id} name={@name} class="" multiple={@multiple} {@rest}>
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <textarea
        id={@id || @name}
        name={@name}
        class={input_style(@errors, @error?, @success?)}
        {@rest}
      >
    <%= @value %></textarea>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <span :if={@success? || @error?} class={["dot", dot_background(@success?, @error?)]} />
      <input
        type={@type}
        name={@name}
        id={@id || @name}
        value={@value}
        class={input_style(@errors, @error?, @success?)}
        placeholder={@label}
        {@rest}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  defp input_style(_err, false, false) do
    "input_default"
  end

  defp input_style(_err, _err?, true) do
    "input_success"
  end

  defp input_style(_err, true, _success?) do
    "input_error"
  end

  defp input_style(errors, _err?, _success?) when is_list(errors) do
    case errors do
      [] -> "input_default"
      [_ | _] -> "input_error"
    end
  end

  defp dot_background(true, _err?) do
    "bg-green-100"
  end

  defp dot_background(_success?, true) do
    "bg-red-100"
  end

  defp dot_background(_success?, _err?), do: "bg-yellow-100"

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="block text-sm font-semibold leading-6 text-zinc-800">
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="phx-no-feedback:hidden mt-3 flex gap-3 text-sm text-red-100 border-1 border-red-100">
      <Lucideicons.x_circle class="mt-0.5 h-4 w-4 fill-red-100 text-white-100" />
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  defp input_equals?(val1, val2) do
    Phoenix.HTML.html_escape(val1) == Phoenix.HTML.html_escape(val2)
  end
end
