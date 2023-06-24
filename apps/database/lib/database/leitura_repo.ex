defmodule Database.LeituraRepo do
  @moduledoc """
  Repositorio especifico para leitura do banco de dados
  """
  use Ecto.Repo, otp_app: :database, adapter: Ecto.Adapters.Postgres, read_only: true
end
