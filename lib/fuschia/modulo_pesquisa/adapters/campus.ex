defmodule Fuschia.ModuloPesquisa.Adapters.Campus do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.Campus

  def to_map(%Campus{} = struct) do
    %{
      id: struct.id,
      nome: struct.nome,
      cidade: struct.cidade,
      pesquisadores: struct.pesquisadores
    }
  end
end
