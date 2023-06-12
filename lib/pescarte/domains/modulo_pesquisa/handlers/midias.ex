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
    with {:ok, user} <- Accounts.fetch_user_by_id_publico(attrs.autor_id),
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
      case Repository.fetch_categoria_by_id_publico(id) do
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
    case Repository.fetch_categoria_by_id_publico(cat_id) do
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
      Ecto.Multi.run(multi, :"tag-#{idx}", fn _, _ ->
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
  defdelegate fetch_midia(midia_id), to: Repository, as: :fetch_midia_by_id_publico

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
  def remove_tags_from_midia(midia_id, []) do
    with {:ok, _} <- Repository.fetch_midia_by_id_publico(midia_id) do
      {:ok, []}
    end
  end

  def remove_tags_from_midia(midia_id, tags_ids) do
    with {:ok, midia} <- Repository.fetch_midia_by_id_publico(midia_id),
         tags_ids = Enum.map(midia.tags, & &1.id_publico) -- tags_ids,
         new_tags = Enum.filter(midia.tags, &(&1.id_publico in tags_ids)),
         {:ok, midia} <- Repository.upsert_midia(midia, %{tags: new_tags}) do
      {:ok, midia.tags}
    end
  end

  @impl true
  def update_midia(attrs) do
    with {:ok, midia} <- Repository.fetch_midia_by_id_publico(attrs.id) do
      Repository.upsert_midia(midia, attrs)
    end
  end

  @impl true
  def update_tag(attrs) do
    with {:ok, tag} <- Repository.fetch_tag_by_id_publico(attrs.id) do
      Repository.upsert_tag(tag, attrs)
    end
  end
end
