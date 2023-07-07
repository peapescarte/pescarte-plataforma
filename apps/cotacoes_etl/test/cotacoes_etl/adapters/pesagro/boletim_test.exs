defmodule CotacoesETL.Adapters.Pesagro.BoletimTest do
  use ExUnit.Case, async: true

  alias CotacoesETL.Adapters.Pesagro.Boletim
  alias CotacoesETL.Schemas.Pesagro.BoletimEntry

  @moduletag :unit

  test "dado um boletim entry, deve retornar uma Cotacao válida" do
    link = "https://example.com/arquivo.pdf"
    arquivo = "arquivo.pdf"
    today = Date.utc_today()
    boletim = %BoletimEntry{link: link, arquivo: arquivo}

    cotacao = Boletim.boletim_to_cotacao(boletim, today)
    assert %{fonte: "pesagro", importada?: false} = cotacao
    assert cotacao.link == link
    assert cotacao.data == today
  end
end
