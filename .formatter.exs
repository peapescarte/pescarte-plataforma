[
  import_deps: [:ecto, :phoenix, :surface],
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{heex,ex,exs}", "{lib,test}/**/*.sface"],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter, Surface.Formatter.Plugin]
]
