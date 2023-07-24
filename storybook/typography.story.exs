defmodule Storybook.Typography do
  use PhoenixStorybook.Story, :page

  alias PlataformaDigital.DesignSystem

  def render(assigns) do
    ~H"""
    <.titles />
    <.body_text />
    """
  end

  defp titles(assigns) do
    ~H"""
    <DesignSystem.text size="h1" color="text-orange-80">
      Títulos
    </DesignSystem.text>
    <hr class="text-black-10" />
    <DesignSystem.text size="h1" color="text-orange-80">
      H1 - Lorem ipsum dolor sit amet
    </DesignSystem.text>
    <DesignSystem.text size="h2">
      H2 - Lorem ipsum dolor sit amet
    </DesignSystem.text>
    <DesignSystem.text size="h3">
      H3 - Lorem ipsum dolor sit amet
    </DesignSystem.text>
    <DesignSystem.text size="h4">
      H4 - Lorem ipsum dolor sit amet
    </DesignSystem.text>
    <DesignSystem.text size="h5">
      H5 - Lorem ipsum dolor sit amet
    </DesignSystem.text>
    """
  end

  defp body_text(assigns) do
    ~H"""
    <DesignSystem.text size="h1" color="text-orange-80">
      Texto
    </DesignSystem.text>
    <hr class="text-black-10" />
    <DesignSystem.text size="lg">
      Grande - Lorem ipsum dolor sit amet
    </DesignSystem.text>
    <DesignSystem.text size="md">
      Médio - Lorem ipsum dolor sit amet
    </DesignSystem.text>
    <DesignSystem.text size="sm">
      Pequeno - Lorem ipsum dolor sit amet
    </DesignSystem.text>
    """
  end
end
