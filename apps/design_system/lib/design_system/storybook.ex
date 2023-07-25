defmodule DesignSystem.Storybook do
  use PhoenixStorybook,
    otp_app: :design_system,
    title: "Pescarte Design System",
    content_path: Path.expand("./storybook", __DIR__),
    # assets path are remote path, not local file-system paths
    css_path: "/design-system/storybook.css",
    js_path: "/design-system/storybook.js",
    sandbox_class: "pescarte-ds"
end
