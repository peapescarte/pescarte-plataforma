defmodule PescarteWeb.DesignSystem do
  @moduledoc """
  Este módulo implementa os compoentes que
  respeitam o design system, que pode ser encontrado no link
  a seguir: https://www.figma.com/file/PhkO37jz3ofCHwc1pHtPyz/PESCARTE?node-id=0%3A1&t=Glx6Q8JbPkPX9gZx-1
  """

  @doc """
  Este componente renderiza um texto, porém com os estilos
  do espaçamento de linha e tamanho de fonte já pré-configurados.

  Também recebe um atributo chamado `color`, que é uma classe do TailwindCSS
  que representa uma cor específica da paleta que o Design System define.

  Caso o atributo `color` não seja fornecido, a cor padrão - `black-80` -
  será utilizada.

  Para ver as cores disponívels, execute o comando `mix tailwind.view`.

  Você pode prover classes adicionais para estilização, com o atributo
  opcional `class`, que recebe uma string.

  ## Exemplo
      <.text size="h1">
      </.text>
  """

  use PescarteWeb, :html

  import Phoenix.HTML.Tag, only: [content_tag: 3]

  attr :size, :string, values: ~w(h1 h2 h3 h4 h5 base lg md sm), required: true
  attr :color, :string, default: "text-color-black-80"
  attr :class, :string, required: false, default: ""

  slot :inner_block

  def text(%{size: "h" <> _} = assigns) do
    ~H"""
    <%= content_tag @size, class: get_text_style(@size, @color, @class) do %>
      <%= render_slot(@inner_block) %>
    <% end %>
    """
  end

  def text(assigns) do
    ~H"""
    <p class={get_text_style(@size, @color, @class)}>
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  defp get_text_style("h1", color, custom_class),
    do: get_text_style("text-3xl leading-10 font-bold" <> " " <> color, custom_class)

  defp get_text_style("h2", color, custom_class),
    do: get_text_style("text-2xl leading-9 font-bold" <> " " <> color, custom_class)

  defp get_text_style("h3", color, custom_class),
    do: get_text_style("text-xl leading-8 font-bold" <> " " <> color, custom_class)

  defp get_text_style("h4", color, custom_class),
    do: get_text_style("text-lg leading-7 font-medium" <> " " <> color, custom_class)

  defp get_text_style(size, color, custom_class) when size in ~w(h5 base),
    do: get_text_style("text-base leading-4 font-medium" <> " " <> color, custom_class)

  defp get_text_style("lg", color, custom_class),
    do: get_text_style("text-lg leading-6 font-regular" <> " " <> color, custom_class)

  defp get_text_style("md", color, custom_class),
    do: get_text_style("text-md leading-5 font-regular" <> " " <> color, custom_class)

  defp get_text_style("sm", color, custom_class),
    do: get_text_style("text-xs leading-4 font-regular" <> " " <> color, custom_class)

  defp get_text_style(final_class, custom_class) do
    final_class <> " " <> custom_class
  end
end
