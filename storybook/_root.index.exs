defmodule Storybook.Root do
  # See https://hexdocs.pm/phoenix_storybook/PhoenixStorybook.Index.html for full index
  # documentation.

  use PhoenixStorybook.Index

  def folder_icon, do: {:fa, "book-open", :light, "lsb-mr-1"}
  def folder_name, do: "Storybook"

  def entry("welcome") do
    [
      name: "Welcome Page",
      icon: {:fa, "hand-wave", :thin}
    ]
  end

  def entry("typography") do
    [
      name: "Typography",
      icon: {:fa, "duotone-group"}
    ]
  end

  # TODO nova cláusula da função entry para tabela `def entry("tabela")`
  def entry("tabela") do
    [
      name: "Componente Tabela",
      icon: {:fa, "duotone-group"}
    ]
  end
  # TODO criar arquivo tabela.story.exs, assim como a typography.story.exs

  def entry("botaofiltro") do
    [
      name: "Botões Relatórios",
      icon: {:fa, "duotone-group"}
    ]
  end

  def entry("iconsearch") do
    [
      name: "Pesquisa com icone",
      icon: {:fa, "duotone-group"}
    ]
  end

  def entry("searchinput") do
    [
      name: "Pesquisa com icone 2",
      icon: {:fa, "duotone-group"}
    ]
  end

end
