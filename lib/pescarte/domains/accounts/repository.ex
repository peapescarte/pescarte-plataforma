defmodule Pescarte.Domains.Accounts.Repository do
  use Pescarte, :repository

  alias Pescarte.Domains.Accounts.IManageRepository
  alias Pescarte.Domains.Accounts.Models.UserToken
  alias Pescarte.Domains.Accounts.Models.Usuario

  @behaviour IManageRepository

  @impl true
  def fetch_user_by_cpf(cpf) do
    Repo.fetch_by(Usuario, cpf: cpf)
  end

  @impl true
  def fetch_user_by_email(email) do
    email
    |> email_query()
    |> Repo.fetch_one()
  end

  @impl true
  def fetch_user_by_token(token, "session", validity_days) do
    token
    |> session_token_query(validity_days)
    |> Repo.fetch_one()
  end

  def fetch_user_by_token(token, context, validity_days)
      when context in ~w(reset_password confirm) do
    token
    |> account_token_query(context, validity_days)
    |> Repo.fetch_one()
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
    from(t in UserToken,
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
    from(t in UserToken,
      where: [token: ^token, contexto: "session"],
      join: u in assoc(t, :usuario),
      where: t.inserted_at > ago(^session_validity_days, "day"),
      select: u
    )
  end

  @impl true
  def list_user do
    Repo.all(Usuario)
  end
end
