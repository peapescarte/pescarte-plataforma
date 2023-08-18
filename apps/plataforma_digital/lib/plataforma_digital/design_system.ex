defmodule PlataformaDigital.DesignSystem do
  @moduledoc """
  Este módulo implementa os componentes que
  respeitam o design system, que pode ser encontrado no link
  a seguir: https://www.figma.com/file/PhkO37jz3ofCHwc1pHtPyz/PESCARTE?node-id=0%3A1&t=Glx6Q8JbPkPX9gZx-1
  """

  use Phoenix.Component
  use PlataformaDigital, :verified_routes

  import Phoenix.HTML.Tag, only: [content_tag: 3]

  alias PlataformaDigital.DesignSystem.SearchInput

  @text_sizes ~w(h1 h2 h3 h4 h5 base lg md sm giant)

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

  attr :size, :string, values: @text_sizes, required: true
  attr :color, :string, default: "text-black-80"
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
    do: get_text_style("text-base leading-5 font-regular" <> " " <> color, custom_class)

  defp get_text_style("sm", color, custom_class),
    do: get_text_style("text-xs leading-4 font-regular" <> " " <> color, custom_class)

  defp get_text_style("giant", color, custom_class),
    do: get_text_style("text-4xl leading-10 font-bold" <> " " <> color, custom_class)

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
  """

  attr :style, :string, values: ~w(primary secondary link), required: true
  attr :submit, :boolean, default: false
  attr :class, :string, default: ""
  attr :click, :string, default: "", doc: ~s(the click event to handle)
  attr :rest, :global, doc: ~s(used for phoenix events like "phx-target")

  slot :inner_block

  def button(assigns) do
    ~H"""
    <button
      type={if @submit, do: "submit", else: "button"}
      class={["btn", "btn-#{@style}", @class]}
      phx-click={@click}
      {@rest}
    >
      <.text :if={@style == "primary"} size="base" color="text-white-100">
        <%= render_slot(@inner_block) %>
      </.text>

      <.text :if={@style != "primary"} size="base" color="text-blue-80">
        <%= render_slot(@inner_block) %>
      </.text>
    </button>
    """
  end

  @doc """
  Um componente de rodapé para a plataforma, expondo os logos
  dos apoiadores e empresas parceiras.

  É um componente estático, sem atributos, sem estado.
  """
  def footer(assigns) do
    ~H"""
    <footer class="flex justify-center items-center " }>
      <img src={~p"/images/footer_logos.svg"} />
    </footer>
    """
  end

  ### COMPONENTES DE INPUT ####

  @doc """
  Componente de checkbox, usado para representar valores que podem
  ter um valor ambíguo.

  O mesmo obrigatoriamente recebe o atributos `label`, que representa a etiqueta,
  o texto nome do campo em questão que é um checkbox.

  Também é possível controlar dinamicamente se o componente será desabilitado
  ou se o valor do checkbox será "assinado" com atributos `disabled` e
  `checked` respectivamente.

  ## Exemplo

      <.checkbox id="send-emails" label="Deseja receber nossos emails?" checked />
  """

  attr :id, :string, required: false
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :label, :string, required: false, default: ""
  attr :field, Phoenix.HTML.FormField
  attr :name, :string

  def checkbox(%{field: %Phoenix.HTML.FormField{}} = assigns) do
    assigns
    |> input()
    |> checkbox()
  end

  def checkbox(assigns) do
    ~H"""
    <div class="flex items-center checkbox-container">
      <input id={@name} name={@name} type="checkbox" checked={@checked} disabled={@disabled} />
      <label for={@name}>
        <.text size="base"><%= @label %></.text>
      </label>
    </div>
    """
  end

  @doc """
  Componente de radio, usado para representar valores que podem
  ter um valor ambíguo.

  O mesmo obrigatoriamente recebe o atributos `label`, que representa a etiqueta,
  o texto nome do campo em questão que é um radio.

  Também é possível controlar dinamicamente se o componente será desabilitado
  ou se o valor do radio será "assinado" com atributos `disabled` e
  `checked` respectivamente.

  ## Exemplo

      <.checkbox id="send-emails" label="Deseja receber nossos emails?" checked />
  """

  attr :id, :string, required: true
  attr :name, :string
  attr :disabled, :boolean, default: false
  attr :checked, :boolean, default: false
  attr :field, Phoenix.HTML.FormField

  slot :label, required: true

  def radio(%{field: %Phoenix.HTML.FormField{}} = assigns) do
    assigns
    |> input()
    |> radio()
  end

  def radio(assigns) do
    ~H"""
    <div class="radio-container">
      <input
        id={@id}
        name={@name}
        type="radio"
        disabled={@disabled}
        checked={@checked}
        class="radio-input"
      />
      <label for={@id} class="radio-label">
        <.text size="base"><%= render_slot(@label) %></.text>
      </label>
    </div>
    """
  end

  @doc """
  Um componente de input de texto, para receber entradas da pessoa
  usuária.

  O mesmo recebe obrigatoriamente os atributos `name` e `label`,
  para que seja possível o formulário que usar este componente
  direcionar corretamente o dado da entrada da pessoa usuária, e a
  etiqueta para ficar visivel sobre o que se trata o input em questão.

  Opcionalmente o componente também recebe o atributo `mask`, que controla
  o formato do texto que será escrito. Por exemplo um documento CPF tem o
  formato "111.111.111-11".

  Além disso é possível definir um texto de ajuda que será colocado "dentro"
  do componte, com o atributo `placeholder`.

  Caso queira dar um valor inicial para o componente, use o atributo `value`!

  ## Exemplo

      <.text_input name="cpf" mask="999.999.999-99" label="CPF" />

      <.text_input name="password" label="Senha" type="password" />
  """

  attr :id, :string, default: nil
  attr :type, :string, default: "text", values: ~w(text password)
  attr :placeholder, :string, required: false, default: ""
  attr :value, :string, required: false
  attr :mask, :string, required: false, default: nil
  attr :valid, :boolean, required: false, default: nil
  attr :label, :string, default: nil
  attr :field, Phoenix.HTML.FormField
  attr :name, :string

  attr :rest, :global, include: ~w(autocomplete disabled pattern placeholder readonly required)

  def text_input(%{field: %Phoenix.HTML.FormField{}} = assigns) do
    assigns
    |> input()
    |> text_input()
  end

  def text_input(assigns) do
    ~H"""
    <fieldset class="text-input-container">
      <label :if={@label} for={@name}>
        <.text size="h4"><%= @label %></.text>
      </label>
      <input
        id={@id}
        name={@name}
        value={@value}
        type={@type}
        placeholder={@placeholder}
        data-inputmask={if @mask, do: "mask: #{@mask}"}
        class={["input", text_input_state(@valid)]}
        {@rest}
      />
      <span :if={!is_nil(@valid)} class="dot">
        <Lucideicons.check_circle_2 :if={@valid} />
        <Lucideicons.x_circle :if={!@valid} />
      </span>
    </fieldset>
    """
  end

  defp text_input_state(nil), do: "input-default"
  defp text_input_state(false), do: "input-error"
  defp text_input_state(true), do: "input-success"

  attr :id, :string, default: nil
  attr :name, :string, default: ""
  attr :value, :string, default: ""
  attr :valid, :boolean, required: false, default: nil
  attr :field, Phoenix.HTML.FormField
  attr :class, :string, default: ""
  attr :placeholder, :string, required: false, default: ""

  slot :label, required: false

  def text_area(%{field: %Phoenix.HTML.FormField{}} = assigns) do
    assigns
    |> input()
    |> text_area()
  end

  def text_area(assigns) do
    ~H"""
    <fieldset class={@class}>
      <.text size="base"><%= render_slot(@label) %></.text>
      <div class="textarea-grow-wrapper">
        <textarea
          id={@id}
          name={@name}
          placeholder={@placeholder}
          class="textarea"
          onInput="this.parentNode.dataset.replicatedValue = this.value"
        >
          <%= @value %>
        </textarea>
      </div>
    </fieldset>
    """
  end

  @doc """
  Um componente de pesquisa. Esta função apenas renderiza um componente
  com estado, definido em `PlataformaDigital.DesignSystem.SearchInput`.

  Além dos atributos obrigatórios: `:id` e `:name`, também recebe as seguintes
  propriedades:

  - `:content`: controla o conteúdo, a lista de itens onde será aplicada a busca;
  - `:placeholder`: controla a mensagem temporária, antes da pessoa usuária digitiar;
  - `:field`: Recebe um campos de um formuário phoenix, dessa forma é possível submetê-lo;
  - `:size`: controla o tamnho do componente, possui apenas duas variações:
    - `base`: tamanho padrão
    - `large`: tamanho grande

  ## Exemplo

      <.search_input id="teste" name="busca_cep" content=["cep1", "cep2"] />

      <.search_input id="teste" name="busca_cep" content=["cep1", "cep2"] size="large" />
  """

  attr :id, :string, required: true
  attr :name, :string, required: true
  attr :content, :list, default: []
  attr :placeholder, :string, default: "Faça uma pesquisa..."
  attr :field, Phoenix.HTML.FormFieldcontent
  attr :size, :string, values: ~w(base large), default: "base"

  def search_input(%{field: %Phoenix.HTML.FormField{}} = assigns) do
    assigns
    |> input()
    |> search_input()
  end

  def search_input(assigns) do
    assigns = assign(assigns, assigns: assigns)

    ~H"""
    <.live_component module={SearchInput} {@assigns} />
    """
  end

  # função interna para criação de inputs dinâmicos
  # cada componente de input possui sua função própria
  # para melhor semântica, como `text_input` ou `checkbox`
  defp input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
  end

  ### ACABA COMPONENTES DE INPUT ####

  @doc """
  Componente de barra de navegação.
  """

  def navbar(assigns) do
    ~H"""
    <header>
      <nav id="navbar" class="w-full h-full navbar">
        <img src="/images/pescarte_logo.svg" class="logo" />
        <!-- TODO: Use named slots to render links -->
        <ul class="nav-menu">
          <li class="nav-item">
            <.text size="h4" color="text-blue-100">Cooperativas</.text>
            <Lucideicons.chevron_down class="text-blue-100" />
          </li>
          <li class="nav-item">
            <.text size="h4" color="text-blue-100">Equipes</.text>
            <Lucideicons.chevron_down class="text-blue-100" />
          </li>
          <li class="nav-item">
            <.text size="h4" color="text-blue-100">Relatórios</.text>
            <Lucideicons.chevron_down class="text-blue-100" />
          </li>
          <li class="nav-item">
            <.text size="h4" color="text-blue-100">Pesca</.text>
            <Lucideicons.chevron_down class="text-blue-100" />
          </li>
          <li class="nav-item">
            <.text size="h4" color="text-blue-100">Quem Somos</.text>
            <Lucideicons.chevron_down class="text-blue-100" />
          </li>
        </ul>
        <PlataformaDigital.DesignSystem.link navigate={~p"/acessar"} styless>
          <.button style="primary" class="login-button">
            <Lucideicons.log_in class="text-white-100" />
            <.text size="base" color="text-white-100">Acessar</.text>
          </.button>
        </PlataformaDigital.DesignSystem.link>
      </nav>
    </header>
    """
  end

  @doc """
  Componente para criar links, que direcionam o usuário para outras
  páginas internas da aplicação ou páginas externas de outras aplicações.

  Recebe os mesmos atributos do componente nativo `Phoenix.Component.link/1`:

  - `navigate`: redireciona a pessoa usuária, sem recarregar a página
  - `patch`: redireciona a pessoa usuária para a mesma página, com parâmetros diferentes
  - `href`: redireciona a pessoa usuária para outra página, interna ou externa da aplicação,
  recarregando a página atual.

  Além desses atributos esse componente precisa de uma `label`, que será o texto
  exibido ao renderizar o link e também aceita um atributo opcional que controla
  o tamanho da fonte do texto renderizado. Os possíveis valores são os mesmos que
  o componente de texto definido em `PlataformaDigital.DesignSystem.text/1`.

  ## Exemplo

      <.link navigate={~p"/app/perfil"}>Ir para Perfil</.link>

      <.link href="https://google.com" text_size="lg">Google.com</.link>

      <.link patch={~p"/app/relatorios"} text_size="lg">Recarregar lista de relatórios</.link>
  """

  attr :navigate, :string, required: false, default: nil
  attr :patch, :string, required: false, default: nil
  attr :href, :string, required: false, default: nil
  attr :method, :string, default: "get", values: ~w(get put post delete patch)
  attr :styless, :boolean, default: false
  attr :class, :string, default: ""

  slot :inner_block

  def link(assigns) do
    ~H"""
    <Phoenix.Component.link
      navigate={@navigate}
      patch={@patch}
      href={@href}
      method={@method}
      class={[if(!@styless, do: "link"), @class]}
    >
      <%= render_slot(@inner_block) %>
    </Phoenix.Component.link>
    """
  end

  @doc """
  Renderiza um formulário simples.

  ## Exemplos

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "a entidade de dados que será usada no formulário"
  attr :as, :any, default: nil, doc: "o parâmetro do lado do servidor para ser coletado os dados"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target),
    doc: "atributos HTML adicionais e opcionais a serem adicionados na tag do formulário"

  slot :inner_block, required: true
  slot :actions, doc: "slot para ações do formulário, como o botão de submissão"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <%= render_slot(@inner_block, f) %>
      <%= for action <- @actions do %>
        <%= render_slot(action, f) %>
      <% end %>
    </.form>
    """
  end

  attr :type, :string, values: ~w(success error warning), required: true
  attr :message, :string, required: true
  attr :id, :string, required: true

  def toast(assigns) do
    ~H"""
    <div id={@id} class={["toast", @type, "show"]} role="alert">
      <div class="toast-icon">
        <Lucideicons.check_circle_2 :if={@type == "success"} />
        <Lucideicons.info :if={@type == "warning"} />
        <Lucideicons.x_circle :if={@type == "error"} />
        <span class="sr-only"><%= @type %> icon</span>
      </div>
      <.text size="lg"><%= @message %></.text>
    </div>
    """
  end

  @doc """
  Renderiza uma tabela com diferentes colunas - versão 4/6/2023:

  """
  slot :column, doc: "Columns with column labels" do
    attr :label, :string, doc: "Column label"
    attr :type, :string, values: ~w(text slot)
  end

  attr :rows, :list, default: []
  attr :"text-color", :string, required: true

  def table(assigns) do
    ~H"""
    <div style="overflow-x: auto">
      <table class="tabela">
        <thead>
          <tr class="header-primary">
            <%= for col <- @column do %>
              <th>
                <.text size="lg" color="text-white-100">
                  <%= Map.get(col, :label, "") %>
                </.text>
              </th>
            <% end %>
          </tr>
        </thead>
        <tbody>
          <%= for row <- @rows do %>
            <tr class="linhas">
              <%= for col <- @column do %>
                <td>
                  <%= if Map.get(col, :type, "text") == "text" do %>
                    <.text size="md" color={Map.get(assigns, :"text-color")}>
                      <%= render_slot(col, row) %>
                    </.text>
                  <% else %>
                    <span :if={col.type == "slot"}>
                      <%= render_slot(col, row) %>
                    </span>
                  <% end %>
                </td>
              <% end %>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end
end
