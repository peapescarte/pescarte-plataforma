defmodule Fuschia.ModuloPesquisa.Adapters.Relatorio do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.Relatorio

  def to_map(%Relatorio{} = struct) do
    %{
      id: struct.id,
      ano: struct.ano,
      mes: struct.mes,
      tipo: struct.tipo,
      link: struct.link,
      pesquisador_cpf: struct.pesquisador_cpf
    }
  end
end
