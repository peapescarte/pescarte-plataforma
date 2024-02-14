defmodule Seeder.ModuloPesquisa.Midia do
  alias Pescarte.Database.Repo.Replica, as: Repo
  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.ModuloPesquisa.Models.Midia
  alias Pescarte.ModuloPesquisa.Models.Midia.Tag
  @behaviour Seeder.Entry

  defp autor_id do
    usuario = Repo.get_by!(Usuario, cpf: "13359017790")
    usuario.id_publico
  end

  defp tags do
    Repo.all(Tag)
  end

  @impl true
  def entries do
    [
      %Midia{
        tags: Enum.take(tags(), 1),
        id_publico: Nanoid.generate(),
        nome_arquivo: "Barra do Furado_Quissamã (Adrya Pessanha de Paula).png",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://lh3.googleusercontent.com/drive-viewer/AEYmBYT_XHpza2oTr2ssZv0XHBWWubGEmLiPUcRikPheu5qXKn7ZmurEOxSEVkfnt3h_e6D532rXJ3_1H3blnj2fLU0UlnQ2aA=s1600"
      },
      %Midia{
        tags: Enum.take(tags(), 2),
        id_publico: Nanoid.generate(),
        nome_arquivo: "Barra do Furado_Quissamã (Adrya Pessanha de Paula)(1).png",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://lh3.googleusercontent.com/drive-viewer/AEYmBYRXrA7b6v1Q7Xwv2Vl1E8nyOsLLo7rEiKxIpPcQmML0fMj1RIMJF1s-FfeNVIDqZadlPebueNzlCuKFCVJwx9-MhWbf=s1600"
      },
      %Midia{
        tags: Enum.take(tags(), 3),
        id_publico: Nanoid.generate(),
        nome_arquivo: "Barra do Furado_Quissamã (Adrya Pessanha de Paula)(2).png",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://lh3.googleusercontent.com/drive-viewer/AEYmBYScjDfLvfoOvrECaXQ173rF6sCxjzc9x6Sa6KQQT-_K1vANatG0_2-D_Mp_OqyGER3NevhusKI0HkZXCij4QX7zdBtI9w=s1600"
      },
      %Midia{
        tags: Enum.take(tags(), 4),
        id_publico: Nanoid.generate(),
        nome_arquivo: "01 Armação dos Búzio armadilha para capturar Siri. Praia da Rasa. Armadilha_ Pulsar (Bruno Siqueira) Bruno dos Santos Siqueira dossantossiqueirabruno@gmail.com .jpeg",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://lh3.googleusercontent.com/drive-viewer/AEYmBYQUeRYUB_zqEt7yqUiGn4wKbo5yxvh9XjuhKW0oaEmavmkcfVBGUDmPzkWm6J-kVkGShKDtA0UX5m8B8bWiBPN6fTXs0A=s1600"
      },
      %Midia{
        tags: tags(),
        id_publico: Nanoid.generate(),
        nome_arquivo: "Peixes em rede de Armação dos Búzios_RJ (Patrícia Pereira).jpeg",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://lh3.googleusercontent.com/drive-viewer/AEYmBYRjL0h2M8HFaYyFBMOVLfHZyi7ZzY3hZ_VlakAyQdZaVGWY6-JianDaylReon14UnptRuZS6u4F3vXBh4yzukL5a7-S=s1600"
      },
      %Midia{
        tags: tags(),
        id_publico: Nanoid.generate(),
        nome_arquivo: "01.1 Pescador de Armação dos Búzios preparando armadilha para capturar Siri (Bruno Siqueira).jpeg",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://lh3.googleusercontent.com/drive-viewer/AEYmBYRpzPWPuA_pMQhZEioii131dkYfufYfLPHlR_ujgfBKFhTOsHc16OyJ0t_hwt6gYtWhOBPLgB4-J8CG8SjO42N9ve3K=s1600"
      },
      %Midia{
        tags: tags(),
        id_publico: Nanoid.generate(),
        nome_arquivo: "03 Siri capturado por pescador em Armação dos Búzios (Bruno Siqueira).jpeg",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://lh3.googleusercontent.com/drive-viewer/AEYmBYS4nctGAq1dI2AfW0XpcWy96dmF63eYvMP5E6i4LqQrWR1Eou0y8gGNb6z-aXzzfrOsO9tbflLLpdJC4PekpVHN4l4oaw=s1600"
      },
      %Midia{
        tags: tags(),
        id_publico: Nanoid.generate(),
        nome_arquivo: "Pescado em Armação dos Búzios_RJ (Patrícia Silva).jpeg",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://lh3.googleusercontent.com/drive-viewer/AEYmBYTicta1aTPcl6wtLpTdDx0W0nQj183eEolEUs7FEEKZatdcOiMs3umeELiw-8KmLULgjUBTUYPDXAMfAriMv1-joA6drA=s1600"
      },
      %Midia{
        tags: tags(),
        id_publico: Nanoid.generate(),
        nome_arquivo: "Mangue de Pedras, Armação dos Búzios (Marcos Vinícius).jpeg",
        tipo: :imagem,
        data_arquivo: Date.utc_today(),
        autor_id: autor_id(),
        link: "https://lh3.googleusercontent.com/drive-viewer/AEYmBYS-dp2mlo39yGnKHS90dmqmgNCiqhtWzSLiJPwajceEZkUSK8o8Y9lE4nKY3CDWwVsQXOt780llt5T-63E5dhpLco3Rzw=s1600"
      }
    ]
  end
end
