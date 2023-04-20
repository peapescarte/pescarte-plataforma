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
      <.text size="h1"> Lorem ipsum dolor sit amet </.text>
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

  @doc """
  Componente de botão, que representa uma ação na plataforma.

  Esse componente possui 2 variantes:

  - Primário
  - Secundário

  que é controlado pelo atributo `style`.

  Esse componente també pode ter um ícone em conjunto com o texto,
  basta informar o nome do ícone da biblioteca [lucide](https://lucide.dev),
  em minúsculo (veja o exemplo abaixo).

  Caso o componente esteja dentro de um formulário, passe o atributo `submit`,
  desta forma o botão irá ser acionado assim que o formua'ário tiver seu
  preenchimento finalizado.

  ## Exemplo
      <.button style="primary"> Primário </.button>

      <.button style="secondary"> Secundário </.button>

      <.button style="primary" submit> Submissão </.button>

      <.button style="primary" icon={:log_in}> Primário com ícone </.button>
  """

  attr :style, :string, values: ~w(primary secondary), required: true
  attr :submit, :boolean, default: false
  attr :icon, :atom, required: false, default: nil

  slot :inner_block

  def button(assigns) do
    ~H"""
    <button type={if @submit, do: "submit", else: "button"} class={["btn", "btn-#{@style}"]}>
      <.icon :if={@icon} name={@icon} />

      <.text :if={@style == "primary"} size="base" color="text-white-100">
        <%= render_slot(@inner_block) %>
      </.text>

      <.text :if={@style != "primary"} size="base" color="text-blue-80">
        <%= render_slot(@inner_block) %>
      </.text>
    </button>
    """
  end

  defp icon(assigns) do
    apply(Lucideicons, assigns.name, [assigns])
  end
end
