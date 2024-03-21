defmodule Pescarte.Database.Repo.Migrations.RenomearIdpublicoTabelas do
  use Ecto.Migration

  def change do

    rename table(:pesquisador), :id_publico, to: :id
    rename table(:campus), :id_publico, to: :id
    rename table(:usuario), :id_publico, to: :id
    rename table(:linha_pesquisa), :id_publico, to: :id
    rename table(:nucleo_pesquisa), :id_publico, to: :id
    rename table(:midia), :id_publico, to: :id
    rename table(:relatorio_pesquisa), :id_publico, to: :id
    rename table(:endereco), :id_publico, to: :id
    rename table(:habitat), :id_publico, to: :id
    rename table(:peixe), :id_publico, to: :id

  end
end
