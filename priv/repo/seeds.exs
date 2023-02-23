defmodule Pescarte.Seeds do
  alias Pescarte.Domains.Accounts
  alias Pescarte.Domains.ModuloPesquisa

  def run do
    validate = fn fun ->
      case fun.() do
        [:ok | _] -> :ok
        _ -> :error
      end
    end

    with :ok <- validate.(&create_cidades/0),
         :ok <- validate.(&create_campus/0),
         :ok <- validate.(&create_users/0),
         :ok <- validate.(&create_pesquisadores/0),
         :ok <- validate.(&create_categorias/0),
         :ok <- validate.(&create_tags/0),
         :ok <- validate.(&create_midias/0) do
      :ok
    end
  end

  defp insert_if_not_exists(attrs, get_fun, insert_fun, field \\ nil) do
    params =
      if field do
        attrs
        |> Map.take([field])
        |> Map.to_list()
      else
        attrs
      end

    case get_fun.(params) do
      {:ok, _} ->
        :ok

      _ ->
        insert_fun.(attrs)
        :ok
    end
  end

  defp create_cidades do
    cidades = [
      %{county: "Campos dos Goytacazes"},
      %{county: "Sorocaba"}
    ]

    for attr <- cidades do
      insert_if_not_exists(attr, &ModuloPesquisa.get_cidade/1, &ModuloPesquisa.create_cidade/1)
    end
  end

  defp create_campus do
    campi = [
      %{
        name: "Universidade Estadual do Norte Fluminense Darcy Ribeiro",
        initials: "UENF",
        cidade_id: elem(ModuloPesquisa.get_cidade(county: "Campos dos Goytacazes"), 1).id
      },
      %{
        name: "Universidade Federal de São Carlos",
        initials: "UFSCar",
        cidade_id: elem(ModuloPesquisa.get_cidade(county: "Sorocaba"), 1).id
      }
    ]

    for attr <- campi do
      insert_if_not_exists(
        attr,
        &ModuloPesquisa.get_campus/1,
        &ModuloPesquisa.create_campus/1,
        :initials
      )
    end
  end

  defp create_users do
    users = [
      %{
        password: "gW3XS8(Eo*mY6/xl",
        password_confirmation: "gW3XS8(Eo*mY6/xl",
        first_name: "Zoey",
        middle_name: "de Souza",
        last_name: "Pessanha",
        birthdate: ~D[2001-07-27],
        confirmed_at: NaiveDateTime.utc_now(),
        cpf: "133.590.177-90",
        contato: %{
          email: "zoey.spessanha@outlook.com",
          address: "R. Conselheiro José Fernandes, 341 - Campos do Goytacazes",
          mobile: "(22)99839-9070"
        }
      },
      %{
        password: "AnnaPescarte!",
        password_confirmation: "AnnaPescarte!",
        first_name: "Annabell",
        middle_name: "Del Real",
        last_name: "Tamariz",
        confirmed_at: NaiveDateTime.utc_now(),
        birthdate: ~D[1969-01-13],
        cpf: "214.047.038-96",
        contato: %{
          email: "annabell@uenf.br",
          address: "Av. Alberto Lamego 2000, Campos dos Goytacazes",
          mobile: "(22)99831-5575"
        }
      },
      %{
        password: "hMmMRL7Ds&59M!",
        password_confirmation: "hMmMRL7Ds&59M!",
        first_name: "Gisele",
        middle_name: "Braga",
        last_name: "Bastos",
        confirmed_at: NaiveDateTime.utc_now(),
        birthdate: ~D[1982-09-10],
        cpf: "014.246.816-93",
        contato: %{
          email: "giselebragabastos.pescarte@gmail.com",
          address: "Rua Cesário Alvin, 150, apto 403, bloco 3",
          mobile: "(32) 99124-1049"
        }
      },
      %{
        password: "dsZx&2ZR74qZ#6",
        password_confirmation: "dsZx&2ZR74qZ#6",
        first_name: "Geraldo",
        last_name: "Timóteo",
        birthdate: ~D[1966-09-25],
        cpf: "553.901.536-34",
        confirmed_at: NaiveDateTime.utc_now(),
        contato: %{
          email: "geraldotimoteo@gmail.com",
          address: "Av. Alberto Lamego, 637, Bloco 11, apart. 202, Bairro: Pq. Califórnia",
          mobile: "(22) 99779-4886"
        }
      },
      %{
        password: "s8mU8DcsgUnH&H",
        password_confirmation: "s8mU8DcsgUnH&H",
        first_name: "Sahudy",
        middle_name: "Montenegro",
        last_name: "González",
        birthdate: ~D[1972-06-16],
        confirmed_at: NaiveDateTime.utc_now(),
        cpf: "214.521.238-88",
        contato: %{
          email: "sahudy.montenegro@gmail.com",
          address: "UFSCar, Rod SP-264 KM 110, Sorocaba",
          mobile: "(15)98126-4233"
        }
      }
    ]

    for attr <- users do
      insert_if_not_exists(attr, &Accounts.get_user/1, &Accounts.register_user/1, :cpf)
    end
  end

  defp create_pesquisadores do
    uenf = elem(ModuloPesquisa.get_campus(initials: "UENF"), 1).id

    user_id = fn cpf -> elem(Accounts.get_user(cpf: cpf), 1).id end

    pesquisadores = [
      %{
        minibio: "Olá",
        bolsa: :pesquisa,
        link_lattes: "https://github.com/zoedsoupe",
        campus_id: uenf,
        user_id: user_id.("133.590.177-90")
      },
      %{
        minibio: """
        Possui graduação em Ciência da Computação - Universidad de la Habana (1992),
        Mestrado em Engenharia Elétrica e Computação pela Universidade Estadual de
        Campinas (1999) e Doutorado em Engenharia Elétrica na área de automação pela
        Universidade Estadual de Campinas (2005).
        """,
        bolsa: :pesquisa,
        link_lattes: "http://lattes.cnpq.br/7484786835288826",
        campus_id: uenf,
        user_id: user_id.("214.047.038-96")
      },
      %{
        minibio: "Eu sou Gisele Braga....",
        bolsa: :celetista,
        link_lattes: "http://lattes.cnpq.br/1675744772217864",
        campus_id: uenf,
        user_id: user_id.("014.246.816-93")
      },
      %{
        minibio: "Eu sou Geraldo, atualmente o coordenador técnico do PEA Pescarte....",
        bolsa: :coordenador_tecnico,
        link_lattes: "http://lattes.cnpq.br/8720264659381887",
        campus_id: uenf,
        user_id: user_id.("553.901.536-34")
      },
      %{
        minibio: """
        Graduada em Ciência da Computação pela Universidad de la Habana.
        Mestrado e Doutorado em Automação pela Universidade Estadual de Campinas
        """,
        bolsa: :consultoria,
        link_lattes: "http://lattes.cnpq.br/9826346918182685",
        campus_id: elem(ModuloPesquisa.get_campus(initials: "UFSCar"), 1).id,
        user_id: user_id.("214.521.238-88")
      }
    ]

    for attr <- pesquisadores do
      insert_if_not_exists(
        attr,
        &ModuloPesquisa.get_pesquisador/1,
        &ModuloPesquisa.create_pesquisador/1,
        :link_lattes
      )
    end
  end

  defp create_categorias do
    categorias = ["autoral", "local", "conteudo", "eventos"]

    for name <- categorias do
      insert_if_not_exists(
        %{name: name},
        &ModuloPesquisa.get_categoria/1,
        &ModuloPesquisa.create_categoria/1
      )
    end
  end

  defp create_tags do
    {:ok, conteudo} = ModuloPesquisa.get_categoria(name: "conteudo")

    tags = [
      %{
        label: "fulano_da_silva",
        categoria_id: elem(ModuloPesquisa.get_categoria(name: "autoral"), 1).id
      },
      %{
        label: "redes",
        categoria_id: conteudo
      },
      %{
        label: "peixes",
        categoria_id: conteudo
      },
      %{
        label: "mar",
        categoria_id: conteudo
      },
      %{
        label: "barco",
        categoria_id: conteudo
      }
    ]

    for attr <- tags do
      insert_if_not_exists(attr, &ModuloPesquisa.get_tag/1, &ModuloPesquisa.create_tag/1, :label)
    end
  end

  defp create_midias do
    {:ok, categoria} = ModuloPesquisa.get_categoria(name: "conteudo")
    tags = ModuloPesquisa.list_tags_by(categoria)

    midias = [
      %{
        tags: tags,
        filename: "IMG20230126.png",
        type: :imagem,
        filedate: Date.utc_today(),
        author_id: ModuloPesquisa.get_pesquisador(link_lattes: "https://github.com/zoedsoupe"),
        link: "https://drive.google.com/uc?export=view&id=1YqVklE01-XPX-6iAO0iYie5acOCk0rhk"
      }
    ]

    for attr <- midias do
      insert_if_not_exists(
        attr,
        &ModuloPesquisa.get_midia/1,
        &ModuloPesquisa.create_midia/1,
        :filename
      )
    end
  end
end

Pescarte.Seeds.run()
