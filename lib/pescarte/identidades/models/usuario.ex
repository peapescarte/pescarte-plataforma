==> file_system
Compiling 7 files (.ex)
Generated file_system app
==> floki
Compiling 2 files (.erl)
Compiling 29 files (.ex)
Generated floki app
==> decimal
Compiling 4 files (.ex)
Generated decimal app
==> thousand_island
Compiling 16 files (.ex)
Generated thousand_island app
==> jason
Compiling 10 files (.ex)
Generated jason app
==> comeonin
Compiling 3 files (.ex)
Generated comeonin app
==> expo
Compiling 2 files (.erl)
Compiling 22 files (.ex)
Generated expo app
==> gettext
Compiling 18 files (.ex)
Generated gettext app
==> absinthe
Compiling 1 file (.erl)
Compiling 260 files (.ex)
Generated absinthe app
==> recase
Compiling 15 files (.ex)
Generated recase app
==> git_hooks
Compiling 16 files (.ex)
Generated git_hooks app
==> ecto
Compiling 56 files (.ex)
Generated ecto app
==> flop
Compiling 17 files (.ex)
Generated flop app
==> credo
Compiling 252 files (.ex)
Generated credo app
==> absinthe_plug
Compiling 18 files (.ex)
Generated absinthe_plug app
==> postgrex
Compiling 68 files (.ex)
Generated postgrex app
==> makeup
Compiling 15 files (.ex)
Generated makeup app
==> makeup_elixir
Compiling 6 files (.ex)
Generated makeup_elixir app
==> makeup_erlang
Compiling 4 files (.ex)
Generated makeup_erlang app
==> ex_doc
Compiling 26 files (.ex)
Generated ex_doc app
==> dialyxir
Compiling 67 files (.ex)
Generated dialyxir app
==> ecto_sql
Compiling 25 files (.ex)
Generated ecto_sql app
==> ex_machina
Compiling 5 files (.ex)
Generated ex_machina app
==> swiss_schema
Compiling 1 file (.ex)
Generated swiss_schema app
==> chromic_pdf
Compiling 34 files (.ex)
Generated chromic_pdf app
==> tzdata
Compiling 17 files (.ex)
Generated tzdata app
==> timex
Compiling 62 files (.ex)
Compiling lib/l10n/gettext.ex (it's taking more than 10s)
Generated timex app
==> castore
Compiling 1 file (.ex)
Generated castore app
==> rustler_precompiled
Compiling 4 files (.ex)
Generated rustler_precompiled app
==> explorer
Compiling 25 files (.ex)

09:30:30.593 [debug] Copying NIF from cache and extracting to /home/douglas/Projects/pescarte/pescarte-plataforma/_build/dev/lib/explorer/priv/native/libexplorer-v0.8.3-nif-2.15-x86_64-unknown-linux-gnu.so.tar.gz
Generated explorer app
==> mint
Compiling 1 file (.erl)
Compiling 20 files (.ex)
Generated mint app
==> finch
Compiling 14 files (.ex)
Generated finch app
==> tesla
Compiling 39 files (.ex)
Generated tesla app
==> supabase_potion
Compiling 11 files (.ex)
Generated supabase_potion app
==> supabase_storage
Compiling 10 files (.ex)
Generated supabase_storage app
==> elixir_make
Compiling 8 files (.ex)
Generated elixir_make app
==> bcrypt_elixir
mkdir -p "/home/douglas/Projects/pescarte/pescarte-plataforma/_build/dev/lib/bcrypt_elixir/priv"
gcc -g -O3 -Wall -Wno-format-truncation -I"/nix/store/wkk3libsw0qby3kqk27c2fswkcfza87r-erlang-26.1.2/lib/erlang/erts-14.1.1/include" -Ic_src -fPIC -shared  c_src/bcrypt_nif.c c_src/blowfish.c -o "/home/douglas/Projects/pescarte/pescarte-plataforma/_build/dev/lib/bcrypt_elixir/priv/bcrypt_nif.so"
Compiling 3 files (.ex)
Generated bcrypt_elixir app
==> brcpfcnpj
Compiling 3 files (.ex)
Generated brcpfcnpj app
==> earmark
Compiling 2 files (.xrl)
Compiling 1 file (.yrl)
Compiling 3 files (.erl)
Compiling 61 files (.ex)
Generated earmark app
==> bandit
Compiling 52 files (.ex)
Generated bandit app
==> websock_adapter
Compiling 4 files (.ex)
Generated websock_adapter app
==> phoenix
Compiling 71 files (.ex)
Generated phoenix app
==> phoenix_live_reload
Compiling 5 files (.ex)
Generated phoenix_live_reload app
==> phoenix_live_view
Compiling 39 files (.ex)
Generated phoenix_live_view app
==> supabase_gotrue
Compiling 30 files (.ex)
Generated supabase_gotrue app
==> absinthe_phoenix
Compiling 9 files (.ex)
Generated absinthe_phoenix app
==> flop_phoenix
Compiling 7 files (.ex)
Generated flop_phoenix app
==> req
Compiling 9 files (.ex)
Generated req app
==> swoosh
Compiling 50 files (.ex)
Generated swoosh app
==> resend
Compiling 17 files (.ex)
Generated resend app
==> sentry
Compiling 30 files (.ex)
Generated sentry app
==> lucide_icons
Compiling 2 files (.ex)
Compiling lib/lucide_icons.ex (it's taking more than 10s)
Generated lucide_icons app
==> phoenix_ecto
Compiling 7 files (.ex)
Generated phoenix_ecto app
defmodule Pescarte.Identidades.Models.Usuario do
  use Pescarte, :model

  import Brcpfcnpj.Changeset, only: [validate_cpf: 3]

  alias Pescarte.Blog.Post
  alias Pescarte.Database.Types.PublicId
  alias Pescarte.Identidades.Models.Contato
  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  @type t :: %Usuario{
          cpf: binary,
          rg: binary,
          data_nascimento: Date.t(),
          papel: atom,
          primeiro_nome: binary,
          sobrenome: binary,
          id: binary,
          pesquisador: Pesquisador.t(),
          contato: Contato.t(),
          external_customer_id: String.t()
        }

  @valid_roles ~w(coletista pesquisador pescador admin)a

  @required_fields ~w(primeiro_nome sobrenome cpf data_nascimento papel)a
  @optional_fields ~w(rg link_avatar contato_id external_customer_id)a

  @lower_pass_format ~r/[a-z]/
  @upper_pass_format ~r/[A-Z]/
  @special_pass_format ~r/[!?@#$%^&*_0-9]/

  @primary_key {:id, PublicId, autogenerate: true}
  schema "usuario" do
    field :cpf, :string
    field :rg, :string
    field :data_nascimento, :date
    field :papel, Ecto.Enum, values: @valid_roles
    field :primeiro_nome, :string
    field :sobrenome, :string
    field :link_avatar, :string
    field :external_customer_id, :string

    has_one :pesquisador, Pesquisador

    belongs_to :contato, Contato, type: :string

    has_many :posts, Post

    timestamps()
  end

  @spec changeset(Usuario.t(), map) :: changeset
  def changeset(%Usuario{} = user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_cpf(:cpf, message: "CPF inválido")
    |> unique_constraint(:cpf)
    |> cast_assoc(:contato, required: false)
    |> foreign_key_constraint(:contato_id)
  end

  @spec password_changeset(Usuario.t() | changeset, map) :: changeset
  def password_changeset(source, attrs \\ %{}) do
    source
    |> cast(attrs, [:senha])
    |> validate_required([:senha])
    |> validate_confirmation(:senha, required: true)
    |> validate_length(:senha, min: 12, max: 72)
    |> validate_format(:senha, @lower_pass_format, message: "pelo menos uma letra minúscula")
    |> validate_format(:senha, @upper_pass_format, message: "pelo menos uma letra maiúscula")
    |> validate_format(:senha, @special_pass_format,
      message: "pelo menos um digito ou caractere digital"
    )
  end

  def user_roles, do: @valid_roles

  def get_external_id(%__MODULE__{} = user) do
    "supabase|" <> external_id = user.external_customer_id
    external_id
  end

  def fetch_by(cpf: cpf) do
    Database.fetch_one(
      from u in __MODULE__,
        where: u.cpf == ^String.replace(cpf, ~r/\D/, ""),
        preload: [:contato, pesquisador: [:usuario]]
    )
  end

  def fetch_by(id: id) do
    Database.fetch_one(
      from u in __MODULE__,
        where: u.id == ^id,
        preload: [:contato, pesquisador: [:usuario]]
    )
  end

  def fetch_by(external_customer_id: external_customer_id) do
    id = "supabase|#{external_customer_id}"

    Database.fetch_one(
      from u in __MODULE__,
        where: u.external_customer_id == ^id,
        preload: [:contato, pesquisador: [:usuario]]
    )
  end

  def all do
    alias Pescarte.Database.Repo
    query = from u in __MODULE__, preload: [:pesquisador, :contato]
    Repo.Replica.all(query)
  end

  def create(params) do
    %__MODULE__{}
    |> changeset(params)
    |> Repo.insert()
  end

  def email_query(email) do
    from(u in Usuario,
      left_join: c in assoc(u, :contato),
      where: c.email_principal == ^email or ^email in c.emails_adicionais,
      order_by: [desc: u.inserted_at],
      limit: 1
    )
  end

  def link_to_external(user \\ %__MODULE__{}, external_id) do
    id = "supabase|" <> external_id

    user
    |> changeset(%{external_customer_id: id})
    |> Repo.update()
  end

  def build_usuario_name(nil), do: ""

  def build_usuario_name(usuario) do
    if usuario.sobrenome do
      usuario.primeiro_nome <> " " <> usuario.sobrenome
    else
      usuario.primeiro_nome
    end
  end
end
