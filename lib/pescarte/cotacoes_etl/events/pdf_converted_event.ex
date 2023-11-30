defmodule Pescarte.CotacoesETL.Events.PDFConvertedEvent do
  @fields ~w(file_path cotacao)a

  @enforce_keys @fields
  defstruct @fields

  def new(%{} = attrs) do
    struct(__MODULE__, attrs)
  end
end
