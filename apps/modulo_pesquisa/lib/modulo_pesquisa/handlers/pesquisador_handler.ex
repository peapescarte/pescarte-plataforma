defmodule ModuloPesquisa.Handlers.PesquisadorHandler do
  alias ModuloPesquisa.Handlers.IManagePesquisadorHandler
  alias ModuloPesquisa.Repository

  @behaviour IManagePesquisadorHandler

  @impl true
  def list_pesquisadores do
    Enum.sort_by(Repository.list_pesquisador(), & &1.usuario.primeiro_nome)
  end

  @impl true
  def struct_to_wire_out_listagem(pesquisador) do
    complete_name = pesquisador.usuario.primeiro_nome <> " " <> pesquisador.usuario.sobrenome

    %{
      bolsa: pesquisador.bolsa,
      nome: complete_name,
      email: pesquisador.usuario.contato.email_principal,
      cpf: pesquisador.usuario.cpf
    }
  end
end
