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

    changeset = Midia.changeset(attrs, [tag])

    assert changeset.valid?
    assert get_change(changeset, :tipo) == :imagem
    assert get_change(changeset, :nome_arquivo) == "arquivo.jpg"
    assert get_change(changeset, :data_arquivo) == ~D[2023-01-01]
    assert get_change(changeset, :link) == "https://exemplo.com/imagem.jpg"
    assert get_change(changeset, :autor_id) == autor.id
    assert tags = get_change(changeset, :tags)
    assert length(tags) == 1
  end

  test "alterações inválidas no changeset sem campos obrigatórios" do
    attrs = %{
      tipo: :imagem,
      nome_arquivo: "arquivo.jpg",
      data_arquivo: ~D[2023-01-01],
      restrito?: false,
      link: "https://exemplo.com/imagem.jpg"
    }

    changeset = Midia.changeset(attrs, [])

    refute changeset.valid?
    assert Keyword.get(changeset.errors, :autor_id)
  end

  test "alterações válidas no changeset de atualização" do
    midia = insert(:midia)
    attrs = %{nome_arquivo: "novo_arquivo.jpg", link: "https://exemplo.com/nova_imagem.jpg"}

    changeset = Midia.update_changeset(midia, attrs)

    assert changeset.valid?
    assert get_change(changeset, :nome_arquivo) == "novo_arquivo.jpg"
    assert get_change(changeset, :link) == "https://exemplo.com/nova_imagem.jpg"
    refute get_change(changeset, :tags)
  end

  test "alterações válidas no changeset de atualização com novas tags" do
    midia = insert(:midia)
    tags = insert_list(2, :tag)
    attrs = %{tags: tags}

    changeset = Midia.update_changeset(midia, attrs)

    assert changeset.valid?
    assert get_change(changeset, :tags)
  end
end
