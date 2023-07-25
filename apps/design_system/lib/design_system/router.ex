defmodule DesignSystem.Router do
  use Phoenix.Router, helpers: false

  import PhoenixStorybook.Router

  scope "/" do
    storybook_assets("/design-system/storybook/assets")

    live_storybook("/design-system/storybook",
      backend_module: DesignSystem.Storybook,
      assets_path: "/design-system/storybook/assets"
    )
  end
end
