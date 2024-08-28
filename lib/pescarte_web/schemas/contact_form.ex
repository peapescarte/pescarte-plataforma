defmodule PescarteWeb.ContactForm do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :form_sender_name, :string
    field :form_sender_email, :string
    field :form_sender_option, :string
    field :form_sender_message, :string
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [
      :form_sender_name,
      :form_sender_email,
      :form_sender_option,
      :form_sender_message
    ])
    |> validate_required([
      :form_sender_name,
      :form_sender_email,
      :form_sender_option,
      :form_sender_message
    ])
    |> validate_format(:form_sender_email, ~r/@/)
    |> validate_length(:form_sender_message, min: 1)
  end

  def apply_action_changeset(params, action) do
    params
    |> changeset()
    |> apply_action(action)
  end
end
