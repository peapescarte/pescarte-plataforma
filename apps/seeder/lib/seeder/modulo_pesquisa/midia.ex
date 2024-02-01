defmodule Seeder.ModuloPesquisa.Midia do
  alias Database.Repo.Replica, as: Repo
  alias Identidades.Models.Usuario
  alias ModuloPesquisa.Models.Midia
  alias ModuloPesquisa.Models.Midia.Tag
  @behaviour Seeder.Entry

  defp autor_id do
    usuario = Repo.get_by!(Usuario, cpf: "133.590.177-90")
    usuario.id_publico
  end

  defp tags do
    Repo.all(Tag)
  end

  @impl true
  def entries do
    [
      %Midia{
        tags: tags(),
        id_publico: Nanoid.generate(),
        nome_arquivo: "IMG2023014.png",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://alavoura.com.br/wp-content/uploads/2021/11/2-IMG_001_PESCA-ARTESANAL_CREDITO-SAA-SP.jpg"
      },
      %Midia{
        tags: tags(),
        id_publico: Nanoid.generate(),
        nome_arquivo: "IMG20230156.png",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://portalvidalivre.com/uploads/content/image/39353/pesca_1.jpg"
      },
      %Midia{
        tags: tags(),
        id_publico: Nanoid.generate(),
        nome_arquivo: "IMG20230151.png",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2020/01/08/13ee9697-c049-46fc-aa66-00913beca50b.jpg"
      },
      %Midia{
        tags: tags(),
        id_publico: Nanoid.generate(),
        nome_arquivo: "IMG20230171.png",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://sebrae.com.br/Sebrae/Portal%20Sebrae/Conte%C3%BAdos/Posts/pesca%20esportiva%20editada%20.jpg"
      },
      %Midia{
        tags: tags(),
        id_publico: Nanoid.generate(),
        nome_arquivo: "IMG20230181.png",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://uploads.metropoles.com/wp-content/uploads/2020/09/15110851/Pescaria-1.jpg"
      }
    ]
  end
end
