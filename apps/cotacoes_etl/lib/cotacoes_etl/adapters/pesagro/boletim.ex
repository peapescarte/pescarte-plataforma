defmodule CotacoesETL.Adapters.Pesagro.Boletim do
  import Ecto.Changeset, only: [apply_action!: 2]
  alias Cotacoes.Models.Cotacao
  alias CotacoesETL.Schemas.Pesagro.BoletimEntry

  def boletins_to_cotacoes(boletins, today) do
    Enum.map(boletins, &boletim_to_cotacao(&1, today))
  end

  def boletim_to_cotacao(%BoletimEntry{link: link}, today) do
    attrs = %{fonte: "pesagro", link: link, data: today, ingested?: false}

    %Cotacao{}
    |> Cotacao.changeset(attrs)
    |> apply_action!(:adapt)
  end
end
