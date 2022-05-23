defmodule Fuschia.Accounts.Adapters.User do
  @moduledoc """
  Define funções que convertem um usuário para
  outros schemas ou mapas
  """

  alias Fuschia.Accounts.Models.User

  def for_jwt(%User{} = struct) do
    %{
      email: struct.contato.email,
      endereco: struct.contato.endereco,
      celular: struct.contato.celular,
      nome_completo: struct.nome_completo,
      perfil: struct.role,
      permissoes: struct.permissoes,
      cpf: struct.cpf,
      data_nascimento: struct.data_nascimento,
      id: struct.id
    }
  end

  def to_map(%User{} = struct) do
    %{
      nome_completo: struct.nome_completo,
      perfil: struct.role,
      ultimo_login: struct.last_seen,
      confirmado_em: struct.confirmed_at,
      ativo: struct.ativo?,
      data_nascimento: struct.data_nascimento,
      id: struct.id,
      contato: struct.contato
    }
  end
end
