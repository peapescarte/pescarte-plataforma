defmodule Pescarte.Identidades.Adapters.UsuarioAdapter do
  alias Pescarte.Identidades.Models.Usuario

  @default_pass "@peaSenha!123@"

  def to_external(%Usuario{} = usuario, pass \\ @default_pass) do
    %{
      role: Atom.to_string(usuario.papel),
      phone: usuario.contato.celular_principal,
      email: usuario.contato.email_principal,
      password: pass,
      app_metadata: %{
        cpf: usuario.cpf,
        first_name: usuario.primeiro_nome,
        last_name: usuario.sobrenome,
        birthdate: usuario.data_nascimento,
        user_id: usuario.id
      }
    }
  end
end
