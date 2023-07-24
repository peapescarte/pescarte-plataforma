defmodule ModuloPesquisa.Handlers.IManageMidiasHandler do
  alias ModuloPesquisa.Models.Midia
  alias ModuloPesquisa.Models.Midia.Categoria
  alias ModuloPesquisa.Models.Midia.Tag

  @callback create_categoria(map) :: {:ok, Categoria.t()} | {:error, Ecto.Changeset.t()}
  @callback create_midia(map) :: {:ok, Midia.t()} | {:error, Ecto.Changeset.t()}
  @callback create_midia_and_tags(map, list(map)) ::
              {:ok, Midia.t(), list(Tag.t())} | {:error, Ecto.Changeset.t()}
  @callback create_tag(map) :: {:ok, Tag.t()} | {:error, Ecto.Changeset.t()}
  @callback create_multiple_tags(list(map)) :: {:ok, list(Tag.t())} | {:error, Ecto.Changeset.t()}

  @callback fetch_categoria(Database.id()) :: {:ok, Categoria.t()} | {:error, :not_found}
  @callback fetch_midia(Database.id()) :: {:ok, Midia.t()} | {:error, :not_found}

  @callback list_categoria :: list(Categoria.t())
  @callback list_midia :: list(Midia.t())
  @callback list_midias_from_tag(Database.id()) :: list(Midia.t())
  @callback list_tag :: list(Tag.t())
  @callback list_tags_from_categoria(Database.id()) :: list(Tag.t())
  @callback list_tags_from_midia(Database.id()) :: list(Tag.t())

  @callback add_tags_to_midia(Database.id(), list(Database.id())) ::
              {:ok, Midia.t()} | {:error, Ecto.Changeset.t()}
  @callback remove_tags_from_midia(Database.id(), list(Database.id())) ::
              {:ok, Midia.t()} | {:error, Ecto.Changeset.t()}

  @callback update_midia(map) :: {:ok, Midia.t()} | {:error, Ecto.Changeset.t()}
  @callback update_tag(map) :: {:ok, Tag.t()} | {:error, Ecto.Changeset.t()}
end
