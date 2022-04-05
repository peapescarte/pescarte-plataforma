alias Fuschia.{
  Accounts,
  Database,
  ModuloPesquisa
}

colors_opts = [
  syntax_colors: [
    number: :light_yellow,
    atom: :light_cyan,
    string: :light_green,
    boolean: :red,
    nil: [:magenta, :bright]
  ],
  ls_directory: :cyan,
  ls_device: :yellow,
  doc_code: :green,
  doc_inline_code: :magenta,
  doc_headings: [:cyan, :underline],
  doc_title: [:cyan, :bright, :underline]
]

prompt =
  "#{IO.ANSI.light_magenta()}λ#{IO.ANSI.reset()}" <>
    "(#{IO.ANSI.cyan()}%counter#{IO.ANSI.reset()})>"

IEx.configure(
  inspect: [limit: :infinity, pretty: true],
  colors: colors_opts,
  default_prompt: prompt
)
