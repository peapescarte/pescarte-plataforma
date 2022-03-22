defmodule Fuschia.ModuloPesquisa.Adapters.CidadeAdapter do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.CidadeModel

  def to_map(%CidadeModel{} = struct) do
    %{
      id: struct.id,
      municipio: struct.municipio,
      campi: struct.campi
    }
  end
end
