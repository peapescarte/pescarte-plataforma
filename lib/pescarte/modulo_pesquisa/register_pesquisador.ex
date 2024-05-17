defmodule Pescarte.ModuloPesquisa.RegisterPesquisador do
  use PescarteWeb, :verified_routes

  alias Pescarte.Database.Repo
  alias Pescarte.Identidades.Adapters.UsuarioAdapter
  alias Pescarte.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Supabase.Auth

  def run(attrs) do
    Repo.transaction(fn ->
      with {:ok, pesquisador} <- do_create_pesquisador(attrs),
           external = UsuarioAdapter.to_external(pesquisador.usuario),
           {:ok, _} <- Auth.Admin.create_user(external),
           :ok <- Auth.reset_password_for_email(external.email, redirect_to: ~p"/confirmar") do
        pesquisador
      else
        {:error, err} -> Repo.rollback(err)
        err -> Repo.rollback(err)
      end
    end)
  end

  @assocs [:linha_pesquisa_principal, :campus, :linhas_pesquisa, usuario: [:contato]]

  defp do_create_pesquisador(attrs) do
    %Pesquisador{}
    |> Pesquisador.changeset(attrs)
    |> Repo.insert()
    |> then(fn
      {:ok, pesquisador} -> {:ok, Repo.preload(pesquisador, @assocs)}
      {:error, _changeset} = err -> err
    end)
  end
end
