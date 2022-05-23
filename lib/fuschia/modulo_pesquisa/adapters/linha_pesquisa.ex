defmodule Fuschia.ModuloPesquisa.Adapters.LinhaPesquisa do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.LinhaPesquisa

  def to_map(%LinhaPesquisa{} = struct) do
    %{
      id: struct.id,
      descricao_curta: struct.descricao_curta,
      descricao_longa: struct.descricao_longa,
      numero: struct.numero,
      nucleo: struct.nucleo
    }
  end
end
