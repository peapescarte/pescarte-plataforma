defmodule Pescarte.Cotacoes.Handlers.CotacaoPescadoHandler do
  alias Pescarte.Cotacoes.Handlers.IManageCotacaoPescadoHandler
  alias Pescarte.Cotacoes.Models.Cotacao
  alias Pescarte.Cotacoes.Models.Fonte
  alias Pescarte.Cotacoes.Models.Pescado
  alias Pescarte.Cotacoes.Repository

  @behaviour IManageCotacaoPescadoHandler

  @impl true
  def insert_cotacao_pescado(%Cotacao{} = cot, %Pescado{} = pes, %Fonte{} = f, attrs) do
    case Repository.fetch_cotacao_pescado_by(
           cotacao_data: cot.data,
           pescado_codigo: pes.codigo,
           fonte_nome: f.nome
         ) do
      {:ok, cot_pescado} ->
        attrs =
          attrs
          |> Map.put(:preco_minimo, attrs[:minima])
          |> Map.put(:preco_maximo, attrs[:maxima])
          |> Map.put(:preco_medio, attrs[:media])
          |> Map.put(:preco_mais_comum, attrs[:mais_comum])

        Repository.upsert_cotacao_pescado(cot_pescado, attrs)

      {:error, :not_found} ->
        attrs
        |> Map.put(:cotacao_data, cot.data)
        |> Map.put(:cotacao_link, cot.link)
        |> Map.put(:pescado_codigo, pes.codigo)
        |> Map.put(:fonte_nome, f.nome)
        |> Map.put(:preco_minimo, attrs[:minima])
        |> Map.put(:preco_maximo, attrs[:maxima])
        |> Map.put(:preco_medio, attrs[:media])
        |> Map.put(:preco_mais_comum, attrs[:mais_comum])
        |> Repository.upsert_cotacao_pescado()
    end
  end
end
