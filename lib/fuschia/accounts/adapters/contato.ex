defmodule Fuschia.Accounts.Adapters.ContatoAdapter do
  @moduledoc false

  alias Fuschia.Accounts.Models.ContatoModel

  def to_map(%ContatoModel{} = struct) do
    %{
      id: struct.id,
      celular: struct.celular,
      email: struct.email,
      endereco: struct.endereco
    }
  end
end
