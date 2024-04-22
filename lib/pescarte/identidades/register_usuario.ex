defmodule Pescarte.Identidades.RegisterUsuario do
  alias Pescarte.Database.Repo
  alias Pescarte.Identidades.Adapters.UsuarioAdapter
  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.Supabase

  def run(attrs, tipo) when tipo in ~w(pesquisador admin)a do
    Repo.transaction(fn ->
      attrs = Map.put(attrs, :papel, tipo)
      {:ok, internal} = do_create_usuario(attrs)
      {:ok, external} = UsuarioAdapter.to_external(internal)
      {:ok, _} = Supabase.Admin.create_user(external)
      internal
    end)
  end

  defp do_create_usuario(attrs) do
    %Usuario{}
    |> Usuario.changeset(attrs)
    |> Usuario.password_changeset(attrs)
    |> Repo.insert()
    |> Repo.preload([:contato])
  end
end
