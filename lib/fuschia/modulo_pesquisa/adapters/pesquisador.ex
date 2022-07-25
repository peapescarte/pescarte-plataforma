defmodule Fuschia.ModuloPesquisa.Adapters.Pesquisador do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.Pesquisador

  def to_map(%Pesquisador{} = struct) do
    %{
      id: struct.id,
      cpf: struct.user.cpf,
      minibiografia: struct.minibiografia,
      tipo_bolsa: struct.tipo_bolsa,
      link_lattes: struct.link_lattes,
      orientador: struct.orientador,
      campus: struct.campus,
      orientandos: struct.orientandos
    }
  end
end
