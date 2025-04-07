defmodule Pescarte.ModuloPesquisa.Adapters.CeletistaAdapter do
  alias Pescarte.Identidades.Models.Usuario

  alias Pescarte.ModuloPesquisa.Models.Celetista, as: Model
  alias Pescarte.ModuloPesquisa.Schemas.Celetista, as: Schema

  @spec internal_to_external(Model.t()) :: Schema.t()
  def internal_to_external(celetista) do
    attrs = %{
      id: celetista.id,
      nome: Usuario.build_usuario_name(celetista.usuario),
      cpf: celetista.usuario.cpf,
      email: celetista.usuario.contato.email_principal
    }

    Schema.parse!(attrs)
  end
end
