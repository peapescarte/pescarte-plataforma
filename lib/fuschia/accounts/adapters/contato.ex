defmodule Fuschia.Accounts.Adapters.Contato do
  @moduledoc false

  alias Fuschia.Accounts.Models.Contato

  def to_map(%Contato{} = struct) do
    %{
      id: struct.id,
      celular: struct.celular,
      email: struct.email,
      endereco: struct.endereco
    }
  end
end
