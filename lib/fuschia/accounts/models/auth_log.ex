defmodule Fuschia.Accounts.Models.AuthLog do
  @moduledoc """
  Authentication log
  """

  use Fuschia.Schema

  import Ecto.Changeset

  alias Fuschia.Accounts.Models.User
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(ip user_agent user_id)a

  schema "auth_log" do
    field :ip, TrimmedString
    field :user_agent, TrimmedString

    belongs_to :user, User

    timestamps(updated_at: false)
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id)
  end
end
