defmodule Fuschia.Jobs.MailerJob do
  @moduledoc false

  use Oban.Worker, queue: :mailer, max_attempts: 4

  require Logger

  alias Fuschia.{Mailer, Parser}

  @doc """
    Deliver an email to partner
    Example:
      iex> %{
              to: "test_user@gmail.com",
              subject: "some subject",
              layout: "notificacao",
              template: "nova_midia",
              assigns: %{user_cpf: "999.999.999-99"}
            }
            |> Fuschia.Jobs.MailerJob.new()
            |> Oban.insert!()
  """
  @impl Oban.Worker
  def perform(%{args: args}) do
    Logger.info("==> [MailerJob] Sending email...")

    Mailer.new_email(
      args["to"],
      args["subject"],
      args["layout"],
      args["template"],
      Parser.atomize_map(args["assigns"]),
      args["base"],
      args["bcc"]
    )
    |> Mailer.deliver!()

    Logger.info("==> [MailerJob] Sent email")

    :ok
  rescue
    error ->
      Logger.error(Exception.format(:error, error, __STACKTRACE__))
      {:error, error}
  end
end
