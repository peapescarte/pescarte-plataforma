defmodule Fuschia.ModuloPesquisa.Adapters.RelatorioAdapter do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.RelatorioModel

  def to_map(%RelatorioModel{} = struct) do
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
