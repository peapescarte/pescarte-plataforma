defmodule Pescarte.Jobs.MailerJob do
  @moduledoc false

  use Oban.Worker, queue: :mailer, max_attempts: 4

  require Logger

  alias Pescarte.Helpers
  alias Pescarte.Mailer

  @doc """
  Deliver an email to partner

  ## Examples
      iex> %{
        to: "test_user@gmail.com",
        subject: "some subject",
        layout: "notificacao",
        template: "nova_midia",
        assigns: %{user_id: "mJUHrGXZBZpNX50x2xkzf"}
      }
      |> Pescarte.Jobs.MailerJob.new()
      |> Oban.insert!()
      > {:ok, %Oban.Job{...}}
  """
  @impl Oban.Worker
  def perform(%{args: args}) do
    Logger.info("==> [MailerJob] Sending email...")

    args["to"]
    |> Mailer.new_email(
      args["subject"],
      args["layout"],
      args["template"],
      Helpers.atomize_map(args["assigns"]),
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
