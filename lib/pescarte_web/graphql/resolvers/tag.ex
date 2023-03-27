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

  def create_tag(%{input: args}, _resolution) do
    insert_tag(args)
  end

  def create_tags(%{input: args}, _resolution) do
    tags = Enum.map(args, &insert_tag/1)

    {:ok, Enum.map(tags, &elem(&1, 1))}
  end

  defp insert_tag(%{categoria_id: cat_id} = args) do
    case ModuloPesquisa.get_categoria(public_id: cat_id) do
      {:ok, categoria} ->
        case ModuloPesquisa.create_tag(%{args | categoria_id: categoria.id}) do
          {:error, %Ecto.Changeset{}} ->
            ModuloPesquisa.get_tag(label: args.label)

          {:ok, tag} ->
            {:ok, tag}
        end

      {:error, :not_found} ->
        {:error, "Categoria não encontrada"}
    end
  end
end
