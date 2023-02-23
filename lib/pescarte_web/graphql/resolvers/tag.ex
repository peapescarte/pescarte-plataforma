defmodule PescarteWeb.GraphQL.Resolvers.Tag do
  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria

  def list(_args, _resolution) do
    {:ok, ModuloPesquisa.list_tags()}
  end

  def list_categorias(%Categoria{} = categoria, _args, _resolution) do
    {:ok, ModuloPesquisa.list_tags_by(categoria)}
  end

  def list_midias(%Midia{} = midia, _args, _Resolution) do
    {:ok, ModuloPesquisa.list_tags_by(midia)}
  end

  def update_tag(%{input: args}, _resolution) do
    with {:ok, tag} <- ModuloPesquisa.get_tag(public_id: args.id) do
      ModuloPesquisa.update_tag(%{tag | label: args.label})
    end
  end

  def create_tag(%{categoria_id: cat_id} = args, _resolution) do
    case ModuloPesquisa.get_categoria(public_id: cat_id) do
      {:ok, categoria} ->
        ModuloPesquisa.create_tag(%{args | categoria_id: categoria.id})

      {:error, :not_found} ->
        {:error, "Categoria não encontrada"}
    end
  end
end
