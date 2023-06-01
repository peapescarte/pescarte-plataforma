defmodule Pescarte.ModuloPesquisa.Models.MidiaTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.ModuloPesquisa.Models.Midia

  @moduletag :unit

  test "alterações válidas no changeset com campos obrigatórios" do
    autor = insert(:user)
    tag = insert(:tag)

    attrs = %{
      tipo: :imagem,
      nome_arquivo: "arquivo.jpg",
      data_arquivo: ~D[2023-01-01],
      link: "https://exemplo.com/imagem.jpg",
      autor_id: autor.id
    }

    assert {:ok, midia} = Midia.changeset(%Midia{}, attrs, [tag])
    assert midia.tipo == :imagem
    assert midia.nome_arquivo == "arquivo.jpg"
    assert midia.data_arquivo == ~D[2023-01-01]
    assert midia.link == "https://exemplo.com/imagem.jpg"
    assert midia.autor_id == autor.id
    assert length(midia.tags) == 1
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    attrs = %{
      tipo: :imagem,
      nome_arquivo: "arquivo.jpg",
      data_arquivo: ~D[2023-01-01],
      restrito?: false,
      link: "https://exemplo.com/imagem.jpg"
    }

    assert {:error, changeset} = Midia.changeset(%Midia{}, attrs, [])
    assert Keyword.get(changeset.errors, :autor_id)
  end

  test "alterações válidas no changeset com novas tags" do
    midia = Repo.preload(insert(:midia), :tags)
    tags = insert_list(2, :tag)

    assert {:ok, midia} = Midia.changeset(midia, %{}, tags)
    assert length(midia.tags) == 2
  end
end
