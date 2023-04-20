[
  import_deps: [:ecto, :phoenix],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: [
    "*.{heex,ex,exs}",
    "priv/*/seeds.exs",
    "storybook/**/*.exs",
    "{config,lib,test}/**/*.{heex,ex,exs}"
  ]
]
