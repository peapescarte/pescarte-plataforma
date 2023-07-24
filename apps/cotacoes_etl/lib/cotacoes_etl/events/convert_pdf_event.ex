defmodule CotacoesETL.Events.ConvertPDFEvent do
  @fields ~w(pdf_path destination_path issuer cotacao format)a

  @enforce_keys @fields
  defstruct @fields

  def new(%{} = attrs) do
    struct(__MODULE__, Map.to_list(attrs))
  end
end
