defmodule Fuschia.Accounts.Logic.UserToken do
  @moduledoc """
  Regras de negócio para tokens de Usuário
  """

  alias Fuschia.Accounts.Models.UserToken

  @hash_algorithm :sha256
  @rand_size 32

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
    {token, %UserToken{token: token, context: "session", user_id: user.id}}
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
     %UserToken{
       token: hashed_token,
       context: context,
       sent_to: sent_to,
       user_id: user.id
     }}
  end
end
