defmodule CotacoesETL.Adapters.Pesagro.Boletim do
  alias CotacoesETL.Schemas.Pesagro.BoletimEntry

  def boletins_to_cotacoes(boletins, today) do
    Enum.map(boletins, &boletim_to_cotacao(&1, today))
  end

  def boletim_to_cotacao(%BoletimEntry{link: link}, today) do
    %{id: Nanoid.generate(), fonte: "pesagro", link: link, data: today, importada?: false}
  end
end
