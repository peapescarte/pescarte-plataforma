defmodule Cotacoes.Factory do
  use ExMachina.Ecto, repo: Database.Repo

  alias Cotacoes.Models.Cotacao
  alias Cotacoes.Models.CotacaoPescado
  alias Cotacoes.Models.Fonte
  alias Cotacoes.Models.Pescado

  def cotacao_factory do
    %Cotacao{
      id: Nanoid.generate_non_secure(),
      data: Date.utc_today(),
      fonte: insert(:fonte).nome,
      link: sequence(:link, &"https://example#{&1}.com")
    }
  end

  def cotacao_pescado_factory do
    %CotacaoPescado{
      id: Nanoid.generate_non_secure(),
      cotacao_data: insert(:cotacao).data,
      fonte_nome: insert(:fonte).nome,
      pescado_codigo: insert(:pescado).codigo,
      preco_minimo: 1000,
      preco_maximo: 2000,
      preco_medio: 1500,
      preco_mais_comum: 1750
    }
  end

  def fonte_factory do
    %Fonte{
      id: Nanoid.generate_non_secure(),
      nome: sequence("fonte"),
      link: sequence(:link, &"https://example#{&1}.com"),
      descricao: sequence("descricao")
    }
  end

  def pescado_factory do
    %Pescado{
      id: Nanoid.generate_non_secure(),
      codigo: sequence("codigo_pescado"),
      embalagem: sequence("embalagem"),
      descricao: sequence("descricao")
    }
  end
end
