defmodule Fuschia.Accounts.UserToken do
  use Fuschia.Schema

  import Ecto.Query

  alias Fuschia.Accounts.User
  alias Fuschia.Types.TrimmedString

  @hash_algorithm :sha256
  @rand_size 32

  # É muito importante manter a expiração do token de redefinição de senha curta,
  # já que alguém com acesso ao e-mail pode assumir a conta.
  @reset_password_validity_in_days 1
  @confirm_validity_in_days 7
  @change_email_validity_in_days 7
  @session_validity_in_days 60

  schema "user_token" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string

    belongs_to :user, User,
      foreign_key: :user_cpf,
      references: :cpf,
      type: TrimmedString

    timestamps(updated_at: false)
  end

  @doc """
  Gera um token que será armazenado em local assinado,
  como sessão ou cookie. À medida que são assinados, aqueles
  tokens não precisam ser encriptados.

  A razão pela qual armazenamos tokens de sessão no banco de dados, mesmo
  embora o Phoenix já forneça um cookie de sessão, é porque
  Os cookies de sessão padrão do Phoenix não são persistentes, eles são
  simplesmente assinado e potencialmente criptografado. Isso significa que eles são
  válido indefinidamente, a menos que você altere a assinatura/criptografia
  sal.

  Portanto, armazená-los permite que o usuário individual
  sessões a expirar. O sistema de token também pode ser estendido
  para armazenar dados adicionais, como o dispositivo usado para fazer login.
  Você pode usar essas informações para exibir todas as sessões válidas
  e dispositivos na interface do usuário e permitir que os usuários expirem
  explicitamente qualquer sessão que considerem inválida.
  """
  def build_session_token(user) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %__MODULE__{token: token, context: "session", user_cpf: user.cpf}}
  end

  @doc """
  Verifica se o token é válido e retorna sua consulta de pesquisa subjacente.

  A consulta retorna o usuário encontrado pelo token, se houver.

  O token é válido se corresponder ao valor no banco de dados e tiver
  não expirou (após @session_validity_in_days).
  """
  def verify_session_token_query(token) do
    query =
      from token in token_and_context_query(token, "session"),
        join: user in assoc(token, :user),
        where: token.created_at > ago(@session_validity_in_days, "day"),
        select: user

    {:ok, query}
  end

  @doc """
  Cria um token e seu hash para ser entregue no email do usuário.

  O token sem hash é enviado para o e-mail do usuário enquanto o
  parte com hash é armazenada no banco de dados. O token original não
  pode ser reconstruído, o que significa que qualquer pessoa com acesso
  somente leitura ao banco de dados não pode usar diretamente
  o token no aplicativo para obter acesso. Além disso, se o usuário alterar
  seu e-mail no sistema, os tokens enviados para o e-mail anterior não são mais
  válido.

  Os usuários podem facilmente adaptar o código existente para fornecer
  outros tipos de métodos de entrega, por exemplo, por números de telefone.
  """
  def build_email_token(user, context) do
    build_hashed_token(user, context, user.contato.email)
  end

  defp build_hashed_token(user, context, sent_to) do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    {Base.url_encode64(token, padding: false),
     %__MODULE__{
       token: hashed_token,
       context: context,
       sent_to: sent_to,
       user_cpf: user.cpf
     }}
  end

  @doc """
  Verifica se o token é válido e retorna sua consulta de pesquisa subjacente.

  A consulta retorna o usuário encontrado pelo token, se houver.

  O token fornecido é válido se corresponder à sua contraparte com hash no
  banco de dados e o e-mail do usuário não foi alterado. Esta função também verifica
  se o token estiver sendo usado dentro de um determinado período, dependendo do
  contexto. Os contextos padrão suportados por esta função são
  "confirm", para e-mails de confirmação de conta, e "reset_password",
  para redefinir a senha. Para verificar solicitações de alteração de e-mail,
  veja `verify_change_email_token_query/2`.
  """
  def verify_email_token_query(token, context) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)
        days = days_for_context(context)

        query =
          from token in token_and_context_query(hashed_token, context),
            join: user in assoc(token, :user),
            join: contato in assoc(user, :contato),
            where: token.created_at > ago(^days, "day") and token.sent_to == contato.email,
            select: user

        {:ok, query}

      :error ->
        :error
    end
  end

  defp days_for_context("confirm"), do: @confirm_validity_in_days
  defp days_for_context("reset_password"), do: @reset_password_validity_in_days

  @doc """
  Verifica se o token é válido e retorna sua consulta de pesquisa subjacente.

  A consulta retorna o usuário encontrado pelo token, se houver.

  Isso é usado para validar solicitações para alterar o usuário
  o email. É diferente de `verify_email_token_query/2` precisamente porque
  `verify_email_token_query/2` valida que o email não foi alterado, o que é
  o ponto de partida por esta função.

  O token fornecido é válido se corresponder à sua contraparte com hash no
  banco de dados e se não expirou (após @change_email_validity_in_days).
  O contexto deve sempre começar com "change:".
  """
  def verify_change_email_token_query(token, "change:" <> _ = context) do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)

        query =
          from token in token_and_context_query(hashed_token, context),
            where: token.created_at > ago(@change_email_validity_in_days, "day")

        {:ok, query}

      :error ->
        :error
    end
  end

  @doc """
  Retorna a estrutura de token para o valor e o contexto de token fornecidos.
  """
  def token_and_context_query(token, context) do
    from __MODULE__, where: [token: ^token, context: ^context]
  end

  @doc """
  Obtém todos os tokens do usuário fornecido para os contextos fornecidos.
  """
  def user_and_contexts_query(user, :all) do
    from t in __MODULE__, where: t.user_cpf == ^user.cpf
  end

  def user_and_contexts_query(user, [_ | _] = contexts) do
    from t in __MODULE__, where: t.user_cpf == ^user.cpf and t.context in ^contexts
  end
end
