# Used by "mix format"
[
  import_deps: [:phoenix, :ecto, :ecto_sql],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{ex,exs,heex}", "{config,lib,test}/**/*.{ex,exs,heex}", "priv/*/seeds.exs"]
]
