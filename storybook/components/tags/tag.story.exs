defmodule Storybook.Components.Buttons.Button do
  use PhoenixStorybook.Story, :component

  def function, do: tag()

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          label: "pesca",
          style: "primary"
        }
      },
      %Variation{
        id: :secondary,
        attributes: %{
          label: "arte",
          style: "secondary"
        }
      }
    ]
  end

  defp tag, do: &PescarteWeb.DesignSystem.tag/1
end
