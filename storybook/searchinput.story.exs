defmodule Storybook.Searchinput do
  use PhoenixStorybook.Story, :page

  alias PlataformaDigital.DesignSystem

  def render(assigns) do
    ~H"""
    <fieldset class="search-input">
      <div class="search-icon">
        <Lucideicons.search />
      </div>
      <input
        id="txtBusca"
        placeholder="Faça uma pesquisa..."
        phx-keyup="search"
        phx-debounce={300}
      />
    </fieldset>
    """
  end
end
