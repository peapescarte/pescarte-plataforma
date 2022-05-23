defmodule Fuschia.ModuloPesquisa.Adapters.Midia do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.Midia

  def to_map(%Midia{} = struct) do
    %{
      id: struct.id,
      tipo: struct.tipo,
      link: struct.link,
      tags: struct.tags
    }
  end
end
