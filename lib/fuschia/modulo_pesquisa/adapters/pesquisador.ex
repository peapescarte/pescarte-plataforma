defmodule Fuschia.ModuloPesquisa.Adapters.PesquisadorAdapter do
  @moduledoc false

  alias Fuschia.ModuloPesquisa.Models.PesquisadorModel

  def to_map(%PesquisadorModel{} = struct) do
    %{
      id: struct.id,
      cpf: struct.usuario_cpf,
      minibiografia: struct.minibiografia,
      tipo_bolsa: struct.tipo_bolsa,
      link_lattes: struct.link_lattes,
      orientador: struct.orientador,
      campus: struct.campus,
      usuario: struct.usuario,
      orientandos: struct.orientandos
    }
  end
end
