defmodule Pescarte.Clients.Auth.User do
  import Peri

  alias Pescarte.Identidades.Models.Usuario
  alias Supabase.GoTrue

  defschema(:app_metadata, %{
    first_name: {:required, :string},
    last_name: {:required, :string},
    cpf: {:required, :string},
    birthdate: {:required, :string},
    user_id: {:required, :string}
  })

  defschema(:user_role, {{:enum, Usuario.user_roles()}, {:transform, &to_string/1}})

  defschema(:create_schema, %{
    email: {:required, :string},
    phone: :string,
    password: {:required, :string},
    role: {:required, get_schema(:user_role)},
    email_confirm: :boolean,
    app_metadata: {:required, get_schema(:app_metadata)}
  })

  def from_session(%GoTrue.Session{} = session) do
    with {:ok, user} <- from_external(session.user) do
      {:ok, %{token: session.access_token, expires_in: session.expires_in, expires_at: session.expires_at, user: user}}
    end
  end

  def from_external(%GoTrue.User{} = user) do
    role_schema = get_schema(:user_role)
    app_metadata_schema = get_schema(:app_metadata)

    with {:ok, role} <- Peri.validate(role_schema, user.role),
         {:ok, app_metadata} <- Peri.validate(app_metadata_schema, user.app_metadata) do
      {:ok,
       %{
         id: user.id,
         email: user.email,
         role: role,
         app_metadata: app_metadata
       }}
    end
  end
end
