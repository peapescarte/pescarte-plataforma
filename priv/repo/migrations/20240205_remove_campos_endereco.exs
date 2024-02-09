defmodule Identidades.EctoRepo.Migrations.AlteraEndereco do
  use Ecto.Migration

  def change do
    alter table(:endereco) do
      remove :bairro
      remove :complemento
      remove :numero
    end
  end
end
