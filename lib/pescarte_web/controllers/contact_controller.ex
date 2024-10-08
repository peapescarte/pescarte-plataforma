defmodule PescarteWeb.ContactController do
  use PescarteWeb, :controller
  require Logger
  alias PescarteWeb.ContactForm

  @sender_email Application.compile_env!(:pescarte, [PescarteWeb, :sender_email])
  @receiver_email Application.compile_env!(:pescarte, [PescarteWeb, :receiver_email])

  def success(conn, _params) do
    current_path = conn.request_path
    render(conn, :success, current_path: current_path, error_message: nil)
  end

  def failed(conn, _params) do
    current_path = conn.request_path
    render(conn, :failed, current_path: current_path, error_message: nil)
  end

  def show(conn, _params) do
    changeset = ContactForm.changeset(%{})
    current_path = conn.request_path
    render(conn, :show, changeset: changeset, current_path: current_path, error_message: nil)
  end

  def send_email(conn, %{"contact_form" => contact_form_params}) do
    case ContactForm.apply_action_changeset(contact_form_params, :insert) do
      {:ok, contact_form} ->
        client = Resend.client()

        with {:ok, _} <- send_email_to_pescarte(client, contact_form),
             {:ok, _} <- send_confirmation_email(client, contact_form) do
          conn
          |> put_flash(:info, "Email enviado com sucesso!")
          |> redirect(to: ~p"/contato/success")
        else
          {:error, reason} ->
            Logger.error("""
            [#{__MODULE__}] ==> Error sending email:
            REASON: #{inspect(reason, pretty: true)}
            LOG_UUID: #{Ecto.UUID.generate()}
            """)

            conn
            |> put_flash(:error, "Erro ao enviar email.")
            |> redirect(to: ~p"/contato/failed")
        end

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Erro na validação do formulário.")
        |> redirect(to: ~p"/contato/failed")
    end
  end

  defp send_email_to_pescarte(client, contact_form) do
    email_data_to_pescarte = %{
      from: @sender_email,
      to: @receiver_email,
      subject: contact_form.form_sender_option,
      html: """
      <p><strong>Nome:</strong> #{contact_form.form_sender_name}</p>
      <p><strong>Assunto:</strong> #{contact_form.form_sender_option}</p>
      <p><strong>Mensagem:</strong> #{contact_form.form_sender_message}</p>
      """
    }

    Resend.Emails.send(client, email_data_to_pescarte)
  end

  defp send_confirmation_email(client, contact_form) do
    email_data_to_form_sender = %{
      from: @sender_email,
      to: contact_form.form_sender_email,
      subject: "Confirmação de recebimento do formulário",
      html: """
      <p>Olá, #{contact_form.form_sender_name},</p>
      <p>Recebemos seu formulário com o assunto: <strong>#{contact_form.form_sender_option}</strong>.</p>
      <p>Em breve retornaremos sua mensagem.</p>
      <p>Atenciosamente,</p>
      <p>Equipe Pescarte</p>
      """
    }

    Resend.Emails.send(client, email_data_to_form_sender)
  end
end
