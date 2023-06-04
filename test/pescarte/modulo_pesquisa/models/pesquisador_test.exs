defmodule Pescarte.ModuloPesquisa.Models.PesquisadorTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @moduletag :unit

  test "alterações válidas no changeset com campos obrigatórios" do
    attrs = %{
      minibio: "Minibio do Pesquisador",
      bolsa: :pesquisa,
      link_lattes: "https://linklattes.com",
      campus_id: insert(:campus).id,
      usuario_id: insert(:user).id,
      rg: "12.123.456-7",
      data_inicio_bolsa: ~D[2023-01-01],
      data_fim_bolsa: ~D[2023-12-31],
      data_contratacao: ~D[2023-01-01],
      formacao: "Formação do Pesquisador"
    }

    assert {:ok, pesquisador} = Pesquisador.changeset(attrs)
    assert pesquisador.minibio == "Minibio do Pesquisador"
    assert pesquisador.bolsa == :pesquisa
    assert pesquisador.link_lattes == "https://linklattes.com"
    assert pesquisador.rg == "12.123.456-7"
    assert pesquisador.formacao == "Formação do Pesquisador"
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    attrs = %{
      minibio: "Minibio do Pesquisador",
      bolsa: :pesquisa,
      link_lattes: "https://linklattes.com",
      campus_id: insert(:campus).id,
      usuario_id: insert(:user).id,
      rg: "12.123.456-7",
      data_inicio_bolsa: ~D[2023-01-01],
      data_fim_bolsa: ~D[2023-12-31],
      data_contratacao: ~D[2023-01-01]
    }

    assert {:error, changeset} = Pesquisador.changeset(attrs)
    assert Keyword.get(changeset.errors, :formacao)
  end

  test "alterações válidas no changeset de atualização" do
    pesquisador = insert(:pesquisador)
    attrs = %{minibio: "Nova Minibio"}

    assert {:ok, pesquisador} = Pesquisador.changeset(pesquisador, attrs)
    assert pesquisador.minibio == "Nova Minibio"
  end

  test "alterações inválidas no changeset de atualização com minibio muito longa" do
    pesquisador = insert(:pesquisador)
    attrs = %{minibio: String.duplicate("a", 281)}

    assert {:error, changeset} = Pesquisador.changeset(pesquisador, attrs)
    assert Keyword.get(changeset.errors, :minibio)
  end
end
