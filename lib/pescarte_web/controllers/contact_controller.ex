defmodule PescarteWeb.ContactController do
  use PescarteWeb, :controller

  def show(conn, _params) do
    current_path = conn.request_path
    render(conn, :show, current_path: current_path, error_message: nil)
  end

  def send_email(conn, %{
        "form-name" => name,
        "form-email" => email,
        "options" => subject,
        "form-message" => message
      }) do
    client = Resend.client(api_key: "RESEND_KEY")

    email_data = %{
      from: email,
      to: "teste@email.com",
      subject: subject,
      html: """
      <p><strong>Nome:</strong> #{name}</p>
      <p><strong>Assunto:</strong> #{subject}</p>
      <p><strong>Mensagem:</strong> #{message}</p>
      """
    }

    case Resend.Emails.send(client, email_data) do
      {:ok, email_response} ->
        IO.puts("Sent email! #{inspect(email_response)}")

        conn
        |> put_flash(:info, "Email enviado com sucesso!")

      {:error, reason} ->
        IO.puts("Error sending email: #{inspect(reason)}")

        conn
        |> put_flash(:error, "Erro ao enviar email.")
    end
  end
end
