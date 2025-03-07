defmodule Pescarte.Municipios do
  import Ecto.Query, warn: false
  alias Pescarte.Database.Repo
  alias Pescarte.Municipios.{Municipio, Unit, DocumentType, Document}

  def list_municipio do
    Repo.all(Municipio)
    |> Repo.preload(units: [documents: :document_type])
  end

  def get_municipio!(id) do
    Repo.get!(Municipio, id)
    |> Repo.preload(units: [documents: :document_type])
  end

  def create_municipio(attrs \\ %{}) do
    %Municipio{}
    |> Municipio.changeset(attrs)
    |> Repo.insert()
  end

  def update_municipio(%Municipio{} = municipio, attrs) do
    municipio
    |> Municipio.changeset(attrs)
    |> Repo.update()
  end

  def delete_municipio(%Municipio{} = municipio) do
    Repo.delete(municipio)
  end

  def change_municipio(%Municipio{} = municipio) do
    Municipio.changeset(municipio, %{})
  end

  def list_units do
    Repo.all(Unit)
    |> Repo.preload([:municipio, documents: :document_type])
  end

  def get_unit!(id) do
    Repo.get!(Unit, id)
    |> Repo.preload([:municipio, documents: :document_type])
  end

  def create_unit(attrs \\ %{}) do
    %Unit{}
    |> Unit.changeset(attrs)
    |> Repo.insert()
  end

  def update_unit(%Unit{} = unit, attrs) do
    unit
    |> Unit.changeset(attrs)
    |> Repo.update()
  end

  def delete_unit(%Unit{} = unit) do
    Repo.delete(unit)
  end

  def change_unit(%Unit{} = unit) do
    Unit.changeset(unit, %{})
  end

  def list_document_types do
    Repo.all(DocumentType)
  end

  def get_document_type!(id) do
    Repo.get!(DocumentType, id)
    |> Repo.preload(:documents)
  end

  def create_document_type(attrs \\ %{}) do
    %DocumentType{}
    |> DocumentType.changeset(attrs)
    |> Repo.insert()
  end

  def update_document_type(%DocumentType{} = document_type, attrs) do
    document_type
    |> DocumentType.changeset(attrs)
    |> Repo.update()
  end

  def delete_document_type(%DocumentType{} = document_type) do
    Repo.delete(document_type)
  end

  def change_document_type(%DocumentType{} = document_type) do
    DocumentType.changeset(document_type, %{})
  end

  def list_documents do
    Repo.all(Document)
    |> Repo.preload([:document_type, unit: :municipio])
  end

  def get_document!(id) do
    Repo.get!(Document, id)
    |> Repo.preload([:document_type, unit: :municipio])
  end

  def create_document(attrs \\ %{}) do
    %Document{}
    |> Document.changeset(attrs)
    |> Repo.insert()
  end

  def update_document(%Document{} = document, attrs) do
    document
    |> Document.changeset(attrs)
    |> Repo.update()
  end

  def delete_document(%Document{} = document) do
    Repo.delete(document)
  end

  def change_document(%Document{} = document) do
    Document.changeset(document, %{})
  end
end
