defmodule PescarteWeb.ContactController do
  use PescarteWeb, :controller

  def show(conn, _params) do
    current_path = conn.request_path
    render(conn, :show, current_path: current_path, error_message: nil)
  end

  def send_email(conn, %{
        "name" => name,
        "email" => email,
        "subject" => subject,
        "message" => message
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
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{message: "Email was successfully sent!"}))

      {:error, reason} ->
        IO.puts("Error sending email: #{inspect(reason)}")

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          500,
          Jason.encode!(%{error: "Could not deliver the email. Reason: #{inspect(reason)}"})
        )
    end
  end
end
