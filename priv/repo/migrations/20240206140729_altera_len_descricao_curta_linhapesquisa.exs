defmodule Pescarte.Database.Repo.Migrations.AlteraLenDescricaoCurtaLinhapesquisa do
  use Ecto.Migration

  def change do
    alter table(:linha_pesquisa) do
      modify :desc_curta, :string, size: 200
    end
  end
end
