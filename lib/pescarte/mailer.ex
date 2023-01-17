defmodule Pescarte.Mailer do
  @moduledoc """
  API pública para criação de emails
  """

  use Swoosh.Mailer, otp_app: :pescarte

  alias Pescarte.Mailer.HTML
  alias Swoosh.Email

  @doc """
  Retorna uma estrutura de e-mail preenchida com um `destinatário` e um
  `subject` e monta o corpo html do email com base no dado
  templates `layout` e `email` e dados `assigns`.
  """
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
  @spec add_attachment(Email.t(), binary) :: Email.t()
  def add_attachment(%Email{} = struct, file) when is_binary(file) do
    Email.attachment(struct, file)
  end

  defp notifications_mail do
    Application.get_env(:pescarte, :pea_pescarte_contato)[:notifications_mail]
  end
end
