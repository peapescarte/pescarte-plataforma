defmodule Fuschia.ModuloPesquisa.Adapters.NucleoAdapter do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.NucleoModel

  def to_map(%NucleoModel{} = struct) do
    %{
      id: struct.id,
      nome: struct.nome,
      descricao: struct.descricao,
      linhas_pesquisa: struct.linhas_pesquisa
    }
  end
end
