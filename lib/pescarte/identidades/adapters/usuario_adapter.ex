defmodule Pescarte.Identidades.Adapters.UsuarioAdapter do
  alias Pescarte.Identidades.Models.Usuario

  @default_pass "@peaSenha!123@"

  @contato_fields ~w(email_principal celular_principal emails_adicionais celulares_adicionais endereco)a

  def to_external(%Usuario{} = usuario, pass \\ @default_pass) do
    %{
      role: usuario.papel,
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
