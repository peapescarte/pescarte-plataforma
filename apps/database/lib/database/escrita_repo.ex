defmodule Database.EscritaRepo do
  @moduledoc """
  Repositorio especifico para escrita do banco de dados
  """
  use Ecto.Repo, otp_app: :database, adapter: Ecto.Adapters.Postgres
end
