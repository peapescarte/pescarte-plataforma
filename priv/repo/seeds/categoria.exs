defmodule CategoriaSeed do
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria

  def entries do
    [
      %Categoria{nome: "autoral", id_publico: Nanoid.generate_non_secure()},
      %Categoria{nome: "local", id_publico: Nanoid.generate_non_secure()},
      %Categoria{nome: "conteudo", id_publico: Nanoid.generate_non_secure()},
      %Categoria{nome: "eventos", id_publico: Nanoid.generate_non_secure()}
    ]
  end
end
