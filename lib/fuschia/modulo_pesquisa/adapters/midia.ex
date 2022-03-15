defmodule Fuschia.ModuloPesquisa.Adapters.MidiaAdapter do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.MidiaModel

  def to_map(%MidiaModel{} = struct) do
    %{
      id: struct.id,
      tipo: struct.tipo,
      link: struct.link,
      tags: struct.tags
    }
  end
end
