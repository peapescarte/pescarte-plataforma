defmodule PescarteWeb.ContactController do
  use PescarteWeb, :controller
  import Ecto.Changeset
  require Logger

  defstruct sender_name: "", sender_email: "", sender_option: "", sender_message: ""

  @types %{
    sender_name: :string,
    sender_email: :string,
    sender_option: :string,
    sender_message: :string
  }

  def changeset(params) do
    {%__MODULE__{}, @types}
    |> cast(params, [:sender_name, :sender_email, :sender_option, :sender_message])
    |> validate_required([:sender_name, :sender_email, :sender_option, :sender_message])
    |> validate_length(:sender_name, min: 3, max: 50)
    |> validate_format(:sender_email, ~r/@/)
    |> validate_length(:sender_message, min: 5)
  end

  def show(conn, _params) do
    changeset = changeset(%{})
    current_path = conn.request_path
    render(conn, :show, changeset: changeset, current_path: current_path, error_message: nil)
  end

  def send_email(conn, %{
        "contact_form" => contact_form_params
      }) do
    changeset = changeset(contact_form_params)

    if changeset.valid? do
      client = Resend.client(api_key: "RESEND_KEY")

      receiver_email = Application.fetch_env!(:pescarte, PescarteWeb.Controller)[:receiver_email]

      email_data = %{
        from: contact_form_params["sender_email"],
        to: receiver_email,
        subject: contact_form_params["sender_option"],
        html: """
        <p><strong>Nome:</strong> #{contact_form_params["sender_name"]}</p>
        <p><strong>Assunto:</strong> #{contact_form_params["sender_option"]}</p>
        <p><strong>Mensagem:</strong> #{contact_form_params["sender_message"]}</p>
        """
      }

      case Resend.Emails.send(client, email_data) do
        {:ok, email_response} ->
          Logger.info("Sent email! #{inspect(email_response)}")

          conn
          |> put_flash(:info, "Email enviado com sucesso!")

        {:error, reason} ->
          Logger.error("Error sending email: #{inspect(reason)}")

          conn
          |> put_flash(:error, "Erro ao enviar email.")
      end
    else
      conn
      |> put_flash(:error, "Erro na validação do formulário.")
    end
  end
end
