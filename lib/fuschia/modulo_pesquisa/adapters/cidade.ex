defmodule Fuschia.ModuloPesquisa.Adapters.Cidade do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.Cidade

  def to_map(%Cidade{} = struct) do
    %{
      id: struct.id,
      municipio: struct.municipio,
      campi: struct.campi
    }
  end
end
