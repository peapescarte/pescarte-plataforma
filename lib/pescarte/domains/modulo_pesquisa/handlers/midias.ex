defmodule Pescarte.Domains.ModuloPesquisa.Handlers.Midias do
  alias Pescarte.Domains.Accounts
  alias Pescarte.Domains.ModuloPesquisa.Handlers.IManageMidiasHandler
  alias Pescarte.Domains.ModuloPesquisa.Repository

  @behaviour IManageMidiasHandler

  @impl true
  defdelegate create_categoria(attrs), to: Repository, as: :upsert_categoria

  @impl true
  defdelegate create_midia(attrs), to: Repository, as: :upsert_midia

  @impl true
  def create_midia_and_tags(attrs, tags_attrs) do
    with {:ok, user} <- Accounts.fetch_user(attrs.autor_id),
         {:ok, raw_tags} <- put_categorias_ids(tags_attrs) do
      attrs
      |> Map.update!(:autor_id, fn _ -> user.id end)
      |> Repository.create_midia_and_tags_multi(raw_tags)
    end
  end

  defp put_categorias_ids(tags) do
    state = %{success: [], errors: []}

    tags
    |> Enum.reduce(state, fn %{categoria_id: id} = tag, state ->
      case Repository.fetch_categoria(id) do
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

  @impl true
  def create_tag(%{categoria_id: cat_id} = attrs) do
    case Repository.fetch_categoria(cat_id) do
      {:ok, categoria} ->
        case Repository.fetch_tag_by_etiqueta(attrs.etiqueta) do
          {:error, :not_found} ->
            Repository.upsert_tag(%{attrs | categoria_id: categoria.id})

          {:ok, tag} ->
            {:ok, tag}
        end

      error ->
        error
    end
  end

  @impl true
  def create_multiple_tags(attrs_list) do
    attrs_list
    |> Enum.with_index()
    |> Enum.reduce(Ecto.Multi.new(), fn {attrs, idx}, multi ->
      multi_id = String.to_existing_atom("tag-#{idx}")

      Ecto.Multi.run(multi, multi_id, fn _, _ ->
        __MODULE__.create_tag(attrs)
      end)
    end)
    |> Pescarte.Repo.transaction()
    |> case do
      {:ok, changes} -> {:ok, Map.values(changes)}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  @impl true
  defdelegate fetch_categoria(categoria_id), to: Repository

  @impl true
  defdelegate fetch_midia(midia_id), to: Repository

  @impl true
  defdelegate list_categoria, to: Repository

  @impl true
  defdelegate list_midia, to: Repository

  @impl true
  defdelegate list_midias_from_tag(tag_id), to: Repository

  @impl true
  defdelegate list_tag, to: Repository

  @impl true
  defdelegate list_tags_from_categoria(categoria_id), to: Repository

  @impl true
  defdelegate list_tags_from_midia(midia_id), to: Repository

  @impl true
  def remove_tags_from_midia(midia_id, tags) do
    with {:ok, midia} <- Repository.fetch_midia(midia_id) do
      tags_ids = Enum.map(midia.tags, & &1.id_publico) -- Enum.map(tags, & &1.id)
      new_tags = Enum.filter(midia.tags, &(&1.id_publico in tags_ids))

      case Repository.upsert_midia(midia, %{tags: new_tags}) do
        {:ok, midia} -> {:ok, midia.tags}
        error -> error
      end
    end
  end

  @impl true
  def update_midia(attrs, tags) do
    with {:ok, tags} <- put_tags_ids(tags),
         {:ok, midia} <- Repository.fetch_midia(attrs.id) do
      midia = Map.put(midia, :id, midia.id)

      attrs
      |> Map.put(:tags, tags)
      |> Repository.upsert_midia(midia)
    end
  end

  defp put_tags_ids(tags) do
    state = %{success: [], errors: []}

    tags
    |> Enum.reduce(state, fn id, state ->
      case Repository.fetch_tag(id) do
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

  @impl true
  def update_tag(attrs) do
    with {:ok, tag} <- Repository.fetch_tag(attrs.id) do
      Repository.upsert_tag(tag, attrs)
    end
  end
end
