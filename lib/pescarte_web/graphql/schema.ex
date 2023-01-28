defmodule PescarteWeb.GraphQL.Schema do
  use Absinthe.Schema

  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  alias PescarteWeb.GraphQL.Middlewares

  # Entidades
  @desc "Representa uma Tag pertencente a uma Categoria"
  object :tag do
    field :label, :string
    field :public_id, :string, name: "id"

    field :midias, list_of(:midia) do
      resolve(fn %Tag{} = tag, _, _ ->
        {:ok, ModuloPesquisa.list_midias_by(tag)}
      end)
    end
  end

  @desc "Representa uma Categoria de tags"
  object :categoria do
    field :name, :string
    field :public_id, :string, name: "id"

    field :tags, list_of(:tag) do
      resolve(fn %Categoria{} = categoria, _, _ ->
        {:ok, ModuloPesquisa.list_tags_by(categoria)}
      end)
    end
  end

  @desc "Tipo que representa uma data ISO8601"
  scalar :date, name: "Date" do
    serialize(&Date.to_iso8601/1)
    parse(&parse_date/1)
  end

  defp parse_date(%Absinthe.Blueprint.Input.String{value: value}) do
    case Date.from_iso8601(value) do
      {:ok, date} -> {:ok, date}
      _error -> :error
    end
  end

  defp parse_date(%Absinthe.Blueprint.Input.Null{}), do: {:ok, nil}
  defp parse_date(_), do: :error

  @desc "Tipos possíveis de Midias"
  enum :midia_type do
    for midia_type <- Midia.types() do
      quote do
        value(unquote(midia_type))
      end
    end
  end

  @desc "Representa uma Mídia genérica da plataforma"
  object :midia do
    field :filename, :string
    field :filedate, :date
    field :link, :string
    field :sensible, :boolean
    field :type, :midia_type
    field :observation, :string
    field :alt_text, :string
    field :public_id, :string, name: "id"

    field :tags, list_of(:tag) do
      resolve(fn %Midia{} = midia, _, _ ->
        {:ok, ModuloPesquisa.list_tags_by(midia)}
      end)
    end
  end

  query do
    field :categorias, list_of(:categoria) do
      resolve(fn _, _ ->
        {:ok, ModuloPesquisa.list_categorias()}
      end)
    end

    field :midias, list_of(:midia) do
      resolve(fn _, _ ->
        {:ok, ModuloPesquisa.list_midias()}
      end)
    end
  end

  # if it's a field for the mutation object, add this middleware to the end
  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [Middlewares.HandleChangesetErrors]
  end

  # if it's any other object keep things as is
  def middleware(middleware, _field, _object), do: middleware
end
