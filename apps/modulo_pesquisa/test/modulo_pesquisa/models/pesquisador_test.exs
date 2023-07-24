defmodule Pescarte.ModuloPesquisa.Models.PesquisadorTest do
  use Database.DataCase, async: true

  import ModuloPesquisa.Factory

  alias ModuloPesquisa.Models.Pesquisador

  @moduletag :unit

  test "alterações válidas no changeset com campos obrigatórios" do
    attrs = %{
      minibio: "Minibio do Pesquisador",
      bolsa: :pesquisa,
      link_lattes: "https://linklattes.com",
      campus_acronimo: insert(:campus).acronimo,
      usuario_id: Identidades.Factory.insert(:usuario).id_publico,
      data_inicio_bolsa: ~D[2023-01-01],
      data_fim_bolsa: ~D[2023-12-31],
      data_contratacao: ~D[2023-01-01],
      formacao: "Formação do Pesquisador"
    }

    changeset = Pesquisador.changeset(%Pesquisador{}, attrs)

    assert changeset.valid?
    assert get_change(changeset, :minibio) == "Minibio do Pesquisador"
    assert get_change(changeset, :bolsa) == :pesquisa
    assert get_change(changeset, :link_lattes) == "https://linklattes.com"
    assert get_change(changeset, :formacao) == "Formação do Pesquisador"
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    attrs = %{
      minibio: "Minibio do Pesquisador",
      bolsa: :pesquisa,
      link_lattes: "https://linklattes.com",
      campus_acronimo: insert(:campus).acronimo,
      usuario_id: Identidades.Factory.insert(:usuario).id_publico,
      data_inicio_bolsa: ~D[2023-01-01],
      data_fim_bolsa: ~D[2023-12-31],
      data_contratacao: ~D[2023-01-01]
    }

    changeset = Pesquisador.changeset(%Pesquisador{}, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :formacao)
  end

  test "alterações válidas no changeset de atualização" do
    pesquisador = insert(:pesquisador)
    attrs = %{minibio: "Nova Minibio"}

    changeset = Pesquisador.changeset(pesquisador, attrs)

    assert changeset.valid?
    assert get_change(changeset, :minibio) == "Nova Minibio"
  end

  test "alterações inválidas no changeset de atualização com minibio muito longa" do
    pesquisador = insert(:pesquisador)
    attrs = %{minibio: String.duplicate("a", 281)}

    changeset = Pesquisador.changeset(pesquisador, attrs)

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :minibio)
  end
end
