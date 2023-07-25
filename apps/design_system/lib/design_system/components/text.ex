defmodule DesignSystem.Components.Text do
  use Phoenix.Component

  import Phoenix.HTML.Tag, only: [content_tag: 3]

  @text_sizes ~w(sm md base lg xl 2xl 3xl 4xl)
  @text_colors ~w(neutra-100 neutra-80 neutra-60 neutra-40 primario-100 primario-80 branco)

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

      <.text size="4xl"> Lorem ipsum dolor sit amet </.text>

      <.text size=""> Lorem ipsum dolor sit amet </.text>
  """

  attr :size, :string, values: @text_sizes, default: "base"
  attr :color, :string, default: "neutra-80", values: @text_colors
  attr :class, :string, default: ""
  attr :is, :string, values: ~w(h1 h2 h3 h4 h5), required: false

  slot :inner_block

  def render(%{is: tag} = assigns) when tag do
    ~H"""
    <%= content_tag @is, class: ["text-#{@size}", "text-#{@color}", @class] do %>
      <%= render_slot(@inner_block) %>
    <% end %>
    """
  end

  def render(assigns) do
    ~H"""
    <p class={["text-#{@size}", "text-#{@color}", @class]}>
      <%= render_slot(@inner_block) %>
    </p>
    """
  end
end
