defmodule PescarteWeb.GraphQL.Resolvers.Midia do
  alias Pescarte.Database

  alias Pescarte.Domains.Accounts
  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  def get(%{id: midia_id}, _resolution) do
    ModuloPesquisa.get_midia(public_id: midia_id)
  end

  def list(_args, _resolution) do
    {:ok, ModuloPesquisa.list_midias()}
  end

  def list_tags(%Tag{} = tag, _args, _resolution) do
    {:ok, ModuloPesquisa.list_midias_by(tag)}
  end

  def remove_tags(args, _resolution) do
    with {:ok, midia} <- ModuloPesquisa.get_midia(public_id: args.midia_id) do
      tags_ids = Enum.map(midia.tags, & &1.public_id) -- Enum.map(args.tags, & &1.id)

      new_tags = Enum.filter(midia.tags, &(&1.public_id in tags_ids))

      case ModuloPesquisa.update_midia(%{midia | tags: new_tags}) do
        {:ok, midia} -> {:ok, midia.tags}
        error -> error
      end
    end
  end

  def update_midia(%{input: args}, _resolution) do
    with {:ok, tags} <- put_tags_ids(args.tags),
         {:ok, midia} <- ModuloPesquisa.get_midia(public_id: args.id) do
      new_tags = ModuloPesquisa.list_tags(Enum.map(tags, & &1.id))
      tags = new_tags
      midia = midia |> Map.merge(args) |> Map.put(:id, midia.id)

      ModuloPesquisa.update_midia(%{midia | tags: tags})
    end
  end

  defp put_tags_ids(tags) do
    state = %{success: [], errors: []}

    tags
    |> Enum.reduce(state, fn id, state ->
      case ModuloPesquisa.get_tag(public_id: id) do
        {:ok, tag} ->
          success = [%{tag | id: tag.id} | state[:success]]

          %{state | success: success}

        {:error, :not_found} ->
          error = "Tag id #{id} é inválida"
          errors = [error | state[:errors]]

          %{state | errors: errors}
      end
    end)
    |> case do
      %{errors: [], success: tags} -> {:ok, tags}
      %{errors: errors} -> {:error, errors}
    end
  end

  def create_midia(%{input: args}, _resolution) do
    tags_attrs = Map.get(args, :tags, [])

    with {:ok, user} <- Accounts.get_user(public_id: args.author_id),
         {:ok, tags} <- put_categorias(tags_attrs) do
      midia_multi(tags, args, user)
    end
  end

  defp put_categorias(tags) do
    state = %{success: [], errors: []}

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
      %{errors: [], success: tags} -> {:ok, tags}
      %{errors: errors} -> {:error, errors}
    end
  end

  defp midia_multi(tags_attrs, midia_attrs, user) do
    tags_attrs
    |> Enum.with_index()
    |> Enum.reduce(Ecto.Multi.new(), fn {attrs, idx}, multi ->
      Ecto.Multi.run(multi, :"tag-#{idx}", fn _, _ ->
        ModuloPesquisa.create_tag(attrs)
      end)
    end)
    |> Ecto.Multi.run(:tags, fn _repo, _changes ->
      {:ok, ModuloPesquisa.list_tags()}
    end)
    |> Ecto.Multi.insert(:midia, fn %{tags: tags} ->
      midia_attrs
      |> Map.update!(:author_id, fn _ -> user.id end)
      |> Midia.changeset(tags)
    end)
    |> Database.transaction()
    |> case do
      {:ok, %{midia: midia}} -> {:ok, midia}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end
end
