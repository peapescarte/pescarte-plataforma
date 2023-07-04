[
  import_deps: [:ecto, :ecto_sql],
  subdirectories: ["priv/*/migrations"],
  inputs: ["*.{ex,exs}", "{lib,test}/**/*.{ex,exs}", "priv/*/seeds.exs"]
]
