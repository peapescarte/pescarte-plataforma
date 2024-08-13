defmodule PescarteWeb.ContactForm do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :sender_name, :string
    field :sender_email, :string
    field :sender_option, :string
    field :sender_message, :string
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:sender_name, :sender_email, :sender_option, :sender_message])
    |> validate_required([:sender_name, :sender_email, :sender_option, :sender_message])
    |> validate_format(:sender_email, ~r/@/)
    |> validate_length(:sender_message, min: 1)
  end

  def apply_action_changeset(params, action) do
    params
    |> changeset()
    |> apply_action(action)
  end
end
