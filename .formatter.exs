# Used by "mix format"
[
  import_deps: [:ecto, :phoenix],
  inputs: ["mix.exs", "config/*.exs"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  subdirectories: ["apps/*"]
]
