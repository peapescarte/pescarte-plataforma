defmodule Pescarte.CotacoesETL.Events.ExtractZIPEvent do
  @fields ~w(zip_path destination_path issuer)a

  @enforce_keys @fields
  defstruct @fields

  def new(%{} = attrs) do
    struct(__MODULE__, Map.to_list(attrs))
  end
end
