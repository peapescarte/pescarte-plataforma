defmodule Pescarte.Identidades.Adapters.UsuarioAdapter do
  alias Pescarte.Identidades.Models.Usuario

  @default_pass "@peaSenha!123@"

  def to_external(%Usuario{} = usuario, pass \\ @default_pass) do
    %{
      role: usuario.papel,
      phone: usuario.contato.celular_principal,
      email: usuario.contato.email_principal,
      password: pass,
      app_metadata: %{
        contato: usuario.contato,
        primeiro_nome: usuario.primeiro_nome,
        sobrenome: usuario.sobrenome,
        nome_completo: Usuario.build_usuario_name(usuario)
      }
    }
  end
end
