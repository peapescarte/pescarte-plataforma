defmodule Fuschia.ModuloPesquisa.IO.PesquisadorRepo do
  use Fuschia, :repo

  alias Fuschia.ModuloPesquisa.Models.Pesquisador

  @required_fields ~w(
    minibiografia
    tipo_bolsa
    link_lattes
    campus_sigla
    usuario_id
  )a

  @optional_fields ~w(orientador_id)a

  @update_fields ~w(minibiografia tipo_bolsa link_lattes)a

  @impl true
  def all do
    Database.all(Pesquisador)
  end

  @impl true
  def fetch(id) do
    fetch(Pesquisador, id)
  end

  @impl true
  def insert(%Pesquisador{} = researcher) do
    researcher
    |> cast(%{}, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:minibiografia, max: 280)
    |> foreign_key_constraint(:usuario_cpf)
    |> foreign_key_constraint(:orientador_cpf)
    |> foreign_key_constraint(:campus_sigla)
    |> put_change(:id, Nanoid.generate())
  end

  @impl true
  def update(%Pesquisador{} = researcher) do
    values = Map.take(researcher, @update_fields)

    %Pesquisador{id: researcher.id}
    |> cast(values, @update_fields)
    |> validate_length(:minibiografia, max: 280)
  end
end
