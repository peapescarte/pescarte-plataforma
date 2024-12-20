defmodule Pescarte.Identidades.Adapters.UsuarioAdapter do
  alias Pescarte.Identidades.Models.Usuario

  @default_pass "@peaSenha!123@"

  @contato_fields ~w(email_principal celular_principal emails_adicionais celulares_adicionais endereco)a

  @type external :: %{
          role: String.t(),
          phone: String.t(),
          email: String.t(),
          password: String.t(),
          app_metadata: %{
            cpf: String.t(),
            rg: String.t(),
            contato: %{
              email_principal: String.t(),
              celular_principal: String.t(),
              emails_adicionais: list(String.t()),
              celulares_adicionais: list(String.t()),
              endereco: String.t()
            },
            primeiro_nome: String.t(),
            sobrenome: String.t(),
            nome_completo: String.t()
          }
        }

  @spec to_external(Usuario.t(), String.t()) :: external
  def to_external(%Usuario{} = usuario, pass \\ @default_pass) do
    %{
      role: Atom.to_string(usuario.papel),
      phone: usuario.contato.celular_principal,
      email: usuario.contato.email_principal,
      password: pass,
      app_metadata: %{
        cpf: usuario.cpf,
        rg: usuario.rg,
        contato: Map.take(usuario.contato, @contato_fields),
        primeiro_nome: usuario.primeiro_nome,
        sobrenome: usuario.sobrenome,
        nome_completo: Usuario.build_usuario_name(usuario)
      }
    }
  end
end
