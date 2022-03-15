defmodule Fuschia.ModuloPesquisa.Adapters.CampusAdapter do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.CampusModel

  def to_map(%CampusModel{} = struct) do
    %{
      id: struct.id,
      nome: struct.nome,
      cidade: struct.cidade,
      pesquisadores: struct.pesquisadores
    }
  end
end
