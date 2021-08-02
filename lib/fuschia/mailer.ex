defmodule Fuschia.Mailer do
  @moduledoc """
  Mailer public API
  """

  use Swoosh.Mailer, otp_app: :fuschia

  alias Fuschia.Mailer.HTML
  alias Swoosh.Email

  @doc """
  Returns an email structure populated with a `recipient` and a
  `subject` and assembles the email's html body based on the given
  templates `layout` and `email` and given `assigns`.
  """
  @spec new_email(
          String.t() | {String.t(), String.t()} | [String.t()] | [{String.t(), String.t()}],
          String.t(),
          String.t(),
          String.t(),
          map,
          String.t(),
          String.t() | {String.t(), String.t()} | [String.t()] | [{String.t(), String.t()}] | []
        ) :: Email.t()
  def new_email(recipient, subject, layout, template, assigns \\ %{}, base \\ "base", bcc \\ [])
      when is_map(assigns) do
    body = HTML.assemble_body(layout, template, assigns, base)

    Email.new()
    |> Email.to(recipient)
    |> Email.bcc(bcc)
    |> Email.from({"Plataforma PEA Pescarte", notifications_mail()})
    |> Email.subject("[Plataforma PEA Pescarte] #{subject}")
    |> Email.html_body(body)
  end

  @doc """
  Add a new attachment to the email.
  """
  @spec add_attachment(Email.t(), String.t()) :: Email.t()
  def add_attachment(%Email{} = struct, file) when is_binary(file) do
    Email.attachment(struct, file)
  end

  defp notifications_mail do
    Application.get_env(:fuschia, :pea_pescarte_contact)[:notifications_mail]
  end
end
