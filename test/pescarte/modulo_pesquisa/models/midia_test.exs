defmodule Pescarte.ModuloPesquisa.Models.MidiaTest do
  use Pescarte.DataCase, async: true

  import Pescarte.ModuloPesquisa.Factory

  alias Pescarte.Identidades.Factory
  alias Pescarte.ModuloPesquisa.Models.Midia

  @moduletag :unit

  test "alterações válidas no changeset com campos obrigatórios" do
    autor = Factory.insert(:usuario)
    tag = insert(:tag)

    attrs = %{
      tipo: :imagem,
      nome_arquivo: "arquivo.jpg",
      data_arquivo: ~D[2023-01-01],
      link: "https://exemplo.com/imagem.jpg",
      autor_id: autor.id_publico
    }

    changeset = Midia.changeset(%Midia{}, attrs, [tag])

    assert changeset.valid?
    assert get_change(changeset, :tipo) == :imagem
    assert get_change(changeset, :nome_arquivo) == "arquivo.jpg"
    assert get_change(changeset, :data_arquivo) == ~D[2023-01-01]
    assert get_change(changeset, :link) == "https://exemplo.com/imagem.jpg"
    assert get_change(changeset, :autor_id) == autor.id_publico
    assert length(get_change(changeset, :tags)) == 1
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    attrs = %{
      tipo: :imagem,
      nome_arquivo: "arquivo.jpg",
      data_arquivo: ~D[2023-01-01],
      restrito?: false,
      link: "https://exemplo.com/imagem.jpg"
    }

    changeset = Midia.changeset(%Midia{}, attrs, [])

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :autor_id)
  end

  test "alterações válidas no changeset com novas tags" do
    midia = Repo.preload(insert(:midia, tags: []), :tags)
    tags = insert_list(2, :tag)

    changeset = Midia.changeset(midia, %{}, tags)

    assert changeset.valid?
    assert length(get_change(changeset, :tags)) == 2
  end
end
