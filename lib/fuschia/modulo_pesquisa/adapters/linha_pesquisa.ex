defmodule Fuschia.ModuloPesquisa.Adapters.LinhaPesquisaAdapter do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.LinhaPesquisaModel

  def to_map(%LinhaPesquisaModel{} = struct) do
    %{
      id: struct.id,
      descricao_curta: struct.descricao_curta,
      descricao_longa: struct.descricao_longa,
      numero: struct.numero,
      nucleo: struct.nucleo
    }
  end
end
