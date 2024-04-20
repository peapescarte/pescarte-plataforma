defmodule Pescarte.Identidades.Repository do
  use Pescarte, :repository

  alias Pescarte.Identidades.IManageRepository
  alias Pescarte.Identidades.Models.Token
  alias Pescarte.Identidades.Models.Usuario

  @behaviour IManageRepository

  @impl true
  def fetch_usuario_by_cpf(cpf) do
    cpf = String.replace(cpf, ~r/\D/, "")
    q = from u in Usuario, where: u.cpf == ^cpf, preload: [:pesquisador, :contato]

    Pescarte.Database.fetch_one(q)
  end

  @impl true
  def fetch_usuario_by_email(email) do
    Pescarte.Database.fetch_one(email_query(email))
  end

  @impl true
  def fetch_usuario(id) do
    Pescarte.Database.fetch_by(Usuario, id: id)
  end

  @impl true
  def fetch_usuario_by_token(token, "session", validity_days) do
    query = session_token_query(token, validity_days)
    Pescarte.Database.fetch_one(query)
  end

  def fetch_usuario_by_token(token, context, validity_days)
      when context in ~w(reset_password confirm) do
    query = account_token_query(token, context, validity_days)
    Pescarte.Database.fetch_one(query)
  end

  defp email_query(email) do
    from(u in Usuario,
      left_join: c in assoc(u, :contato),
      where: c.email_principal == ^email or ^email in c.emails_adicionais,
      order_by: [desc: u.inserted_at],
      limit: 1
    )
  end

  defp account_token_query(token, context, confirm_validity_days) do
    from(t in Token,
      where: [token: ^token, contexto: ^context],
      join: u in assoc(t, :usuario),
      join: c in assoc(u, :contato),
      where:
        t.inserted_at > ago(^confirm_validity_days, "day") and
          (t.enviado_para == c.email_principal or t.enviado_para in c.emails_adicionais),
      select: u
    )
  end

  defp session_token_query(token, session_validity_days) do
    from(t in Token,
      where: [token: ^token, contexto: "session"],
      join: u in assoc(t, :usuario),
      where: t.inserted_at > ago(^session_validity_days, "day"),
      select: u
    )
  end

  @impl true
  def insert_usuario(changeset) do
    Repo.insert(changeset)
  end

  @impl true
  def list_usuario do
    Repo.replica().all(Usuario)
  end
end
