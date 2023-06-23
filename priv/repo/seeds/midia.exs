defmodule MidiaSeed do
  alias Pescarte.Domains.Accounts.Models.Usuario
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Repo

  defp autor_id do
    {:ok, usuario} = Repo.fetch_by(Usuario, cpf: "133.590.177-90")
    usuario.id_publico
  end

  defp tags do
    Repo.all(Tag)
  end

  def entries do
    [
      %Midia{
        tags: tags(),
        id_publico: Nanoid.generate(),
        nome_arquivo: "IMG20230126.png",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://drive.google.com/uc?export=view&id=1YqVklE01-XPX-6iAO0iYie5acOCk0rhk"
      },
      %Midia{
        tags: tags(),
        id_publico: Nanoid.generate(),
        nome_arquivo: "IMG2023014.png",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://drive.google.com/uc?export=view&id=1SqVklE01-XPX-6iAO0iYie5acOCk0rhk"
      }
    ]
  end
end
