defmodule Fuschia.ModuloPesquisa.Adapters.Nucleo do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.Nucleo

  def to_map(%Nucleo{} = struct) do
    %{
      id: struct.id,
      nome: struct.nome,
      descricao: struct.descricao,
      linhas_pesquisa: struct.linhas_pesquisa
    }
  end
end
