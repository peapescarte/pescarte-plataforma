defmodule Pescarte.Identidades.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Pescarte.Database.Repo

  alias Pescarte.Identidades.Models.Contato
  alias Pescarte.Identidades.Models.Endereco
  alias Pescarte.Identidades.Models.Token
  alias Pescarte.Identidades.Models.Usuario

  def contato_factory do
    %Contato{
      email_principal: sequence(:email, &"test-#{&1}@example.com"),
      celular_principal: sequence(:celular, &"221245167#{digit_rem(&1 + 1)}"),
      emails_adicionais: sequence_list(:emails, &"test-#{&1}@example.com", limit: 3),
      celulares_adicionais: sequence_list(:celulares, &"221234567#{digit_rem(&1)}", limit: 4),
      endereco_cep: __MODULE__.insert(:endereco).cep
    }
  end

  def endereco_factory do
    %Endereco{
      cep: sequence("00000000"),
      cidade: sequence("Cidade"),
      complemento: "Um complemento",
      estado: "Rio de Janeiro",
      numero: "100",
      rua: "Rua Exemplo de Queiras"
    }
  end

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "Hello World 42!"

  def usuario_factory do
    %Usuario{
      id_publico: Nanoid.generate_non_secure(),
      rg: sequence(:rg, &"131213465#{&1}"),
      tipo: sequence(:role, ["admin", "pesquisador"]),
      primeiro_nome: sequence(:first, &"User #{&1}"),
      sobrenome: sequence(:last, &"Last User #{&1}"),
      cpf: Brcpfcnpj.cpf_generate(),
      data_nascimento: Date.utc_today(),
      hash_senha: "$2b$12$6beq5zEplVZjji7Jm7itJuTXd3wH9rDN.V5VRcaS/A8YJ28mi1LBG",
      contato_email: insert(:contato).email_principal,
      senha: senha_atual()
    }
  end

  def usuario_creation_factory do
    user = build(:usuario)
    user |> Map.from_struct() |> Map.put(:senha_confirmation, user.senha)
  end

  def email_token_factory do
    context = sequence(:contexto, ["confirm", "reset_password"])
    token = :crypto.strong_rand_bytes(32)
    hashed = :crypto.hash(:sha256, token)
    contato = insert(:contato)
    user = insert(:usuario, contato_email: contato.email_principal)

    %Token{
      contexto: context,
      usuario_id: user.id_publico,
      enviado_para: contato.email_principal,
      token: hashed
    }
  end

  def session_token_factory do
    contato = insert(:contato)
    user = insert(:usuario, contato_email: contato.email_principal)

    %Token{
      contexto: "session",
      usuario_id: user.id_publico,
      enviado_para: contato.email_principal,
      token: :crypto.strong_rand_bytes(32)
    }
  end

  def senha_atual do
    "Password!123"
  end

  defp sequence_list(label, custom, opts) do
    limit = Keyword.get(opts, :limit, 1)

    sequences =
      for _ <- 1..limit do
        sequence(label, custom)
      end

    if limit > 1, do: sequences, else: hd(sequences)
  end

  defp digit_rem(digit) do
    (digit < 10 && "#{digit}#{digit - 1}") || digit + 1
  end
end
