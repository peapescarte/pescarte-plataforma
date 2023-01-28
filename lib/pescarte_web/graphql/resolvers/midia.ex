defmodule PescarteWeb.GraphQL.Resolvers.Midia do
  alias Pescarte.Database

  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  def list(_args, _resolution) do
    {:ok, ModuloPesquisa.list_midias()}
  end

  def list_tags(%Tag{} = tag, _args, _resolution) do
    {:ok, ModuloPesquisa.list_midias_by(tag)}
  end

  def create_midia(%{tags: tags_attrs} = args, _resolution) do
    with {:ok, tags} <- put_categorias(tags_attrs) do
      midia_multi(tags, args)
    end
  end

  defp put_categorias(tags) do
    state = %{succes: [], errors: []}

    tags
    |> Enum.reduce(state, fn %{categoria_id: id} = tag, state ->
      case ModuloPesquisa.get_categoria(public_id: id) do
        {:ok, categoria} ->
          success = [%{tag | categoria_id: categoria.id} | state[:success]]

          %{state | success: success}

        {:error, :not_found} ->
          error = "Categoria id #{id} é inválida"
          errors = [error | state[:errors]]

          %{state | errors: errors}
      end
    end)
    |> case do
      %{errors: [], succes: tags} -> {:ok, tags}
      %{errors: errors} -> {:error, errors}
    end
  end

  defp midia_multi(tags_attrs, midia_attrs) do
      tags_attrs
      |> Enum.reduce(Ecto.Multi.new(), fn attrs, multi ->
        Ecto.Multi.run(multi, :tag, fn _, _ ->
          ModuloPesquisa.create_tag(attrs)
        end)
      end)
      |> Ecto.Multi.run(:tags, fn _repo, _changes ->
        {:ok, ModuloPesquisa.list_tags()}
      end)
      |> Ecto.Multi.insert(:midia, fn tags ->
        Midia.changeset(midia_attrs, tags)
      end)
      |> Database.transaction()
      |> case do
        {:ok, %{midia: midia}} -> {:ok, midia}
        {:error, _, changeset, _} -> {:error, changeset}
      end
  end
end
