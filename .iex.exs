alias Fuschia.{Context, Entities, Queries}

alias Fuschia.Queries.{
  Campi,
  Cidades,
  LinhasPesquisas,
  Midias,
  Nucleos,
  Pesquisadores,
  Relatorios
}

alias Context.Users

alias Fuschia.Entities.{
  Campus,
  Cidade,
  Contato,
  LinhaPesquisa,
  Midia,
  Nucleo,
  Pesquisador,
  Relatorio,
  User
}

alias Fuschia.Repo

colors_opts = [
  syntax_colors: [
    number: :light_yellow,
    atom: :light_cyan,
    string: :light_green,
    boolean: :light_blue,
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
  [
    # ANSI CHA, move cursor to column 1
    "\e[G",
    :light_magenta,
    # plain string
    "ﬦ",
    ">",
    :white,
    :reset
  ]
  |> IO.ANSI.format()
  |> IO.chardata_to_string()

IEx.configure(
  inspect: [limit: :infinity, pretty: true],
  colors: colors_opts,
  default_prompt: prompt
)
