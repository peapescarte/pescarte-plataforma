defmodule Fuschia.ModuloPesquisa.IO.RelatorioRepo do
  use Fuschia, :repo

  alias Fuschia.ModuloPesquisa.Models.Relatorio

  @required_fields ~w(ano mes tipo pesquisador_id raw_content)a

  @optional_fields ~w(link)a

  @update_fields ~w(ano mes tipo link raw_content)a

  def changeset(%Relatorio{} = report, attrs \\ %{}) do
    report
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:pesquisador_id)
    |> put_change(:id, Nanoid.generate())
  end

  @impl true
  def all do
    Database.all(Relatorio)
  end

  @impl true
  def fetch(id) do
    fetch(Relatorio, id)
  end

  @impl true
  def insert(%Relatorio{} = report) do
    report
    |> changeset()
    |> Database.insert()
  end

  @impl true
  def update(%Relatorio{} = report) do
    values = Map.take(report, @update_fields)

    %Relatorio{id: report.id}
    |> cast(values, @update_fields)
    |> Database.update()
  end
end
