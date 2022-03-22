defmodule Fuschia.Accounts.Models.AuthLogModel do
  @moduledoc """
  Authentication log
  """

  use Fuschia.Schema

  import Ecto.Changeset

  alias Fuschia.Accounts.Models.UserModel
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(ip user_agent user_cpf)a

  @foreign_key_type :string
  schema "auth_log" do
    field :ip, TrimmedString
    field :user_agent, TrimmedString

    belongs_to :user, UserModel, foreign_key: :user_cpf, references: :cpf

    timestamps(updated_at: false)
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_cpf)
  end
end
