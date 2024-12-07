defmodule Pescarte.Scripts.PesquisaIngestion do
  import Ecto.Changeset
  import Explorer.Series

  alias Ecto.Multi, as: TRX
  alias Pescarte.Database.Repo

  alias Pescarte.Identidades.Models.Contato
  alias Pescarte.Identidades.RegisterUsuario

  alias Pescarte.ModuloPesquisa.Models.Campus
  alias Pescarte.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.ModuloPesquisa.Models.PesquisadorLP

  require Explorer.DataFrame, as: DF

  @rename_hashmap %{
    "ATIVO (S/N)" => "ativo?",
    "BOLSISTA" => "nome_completo",
    "BOLSISTA - NOME" => "primeiro_nome",
    "BOLSISTA - SOBRENOME" => "sobrenome",
    "CAMPUS" => "campus",
    "CEP" => "cep",
    "CEP - CAMPUS" => "campus_cep",
    "CPF" => "cpf",
    "DATA DA CONTRATAÇÃO" => "data_contratacao",
    "Data de Nascimento" => "data_nascimento",
    "Data de fim BOLSA" => "data_fim_bolsa",
    "Data de início BOLSA" => "data_inicio_bolsa",
    "E-mail" => "email",
    "ENDEREÇO - CAMPUS (sem cidade e nem cep)" => "campus_endereco",
    "Endereço" => "endereco",
    "FORMAÇÃO" => "formacao",
    "Foto" => "link_foto",
    "GÊNERO" => "genero",
    "LINK LATTES" => "link_lattes",
    "MINIBIOGRAFIA" => "minibio",
    "NOME LINHA DE PESQUISA" => "linha_pesquisa",
    "NoLP" => "linha_pesquisa_numero",
    "NÚCLEO" => "nucleo",
    "ORIENTAÇÃO" => "orientacao",
    "RG" => "rg",
    "Responsavel pela LP? (insira o numero da LP)" => "responsavel?",
    "TIPO DE BOLSA" => "bolsa",
    "Telefone" => "telefone",
    "UNIVERSIDADE" => "nome_universidade",
    "UNIVERSIDADE SIGLA" => "acronimo"
  }

  @headers Map.values(@rename_hashmap)

  def run do
    sheet_url = Application.get_env(:pescarte, :pesquisa_ingestion)[:sheet_url]

    with {:ok, data} <- DF.from_csv(sheet_url) do
      sanitized_data = sanitize_data(data)

      TRX.new()
      |> TRX.merge(&insert_nucleo_pesquisa(&1, sanitized_data))
      |> TRX.merge(&insert_linha_pesquisa(&1, sanitized_data))
      |> TRX.merge(&insert_campus(&1, sanitized_data))
      |> TRX.merge(&insert_usuario(&1, sanitized_data))
      |> TRX.merge(&insert_pesquisador(&1, sanitized_data))
      |> TRX.merge(&insert_pesquisador_lp(&1, sanitized_data))
      # |> TRX.run(:teste, fn _, _ -> Repo.rollback("tudo certo") end)
      |> Repo.transaction(timeout: :infinity)
      |> then(fn
        {:ok, result} -> {:ok, result}
        {:error, _key, changeset, _rest} -> {:error, changeset}
      end)
    end
  end

  defp sanitize_data(data) do
    data
    |> DF.rename(@rename_hashmap)
    |> DF.drop_nil()
    |> DF.distinct(@headers)
  end

  @nucleo_a_desc """
  O Núcleo A de pesquisas do PEA Pescarte envolve um variado número de pesquisadores interessados na CULTURA e nos CONFLITOS SOCIOAMBIENTAIS que envolvem as comunidades da pesca artesanal nos 10 municípios de atuação do PEA Pescarte no Estado do Rio de Janeiro. Suas pesquisas, de natureza analítica e muitas vezes interativa e intervencionista, envolvem questões como as memórias, identidades e fazeres artesanais nestas comunidades; a natureza do trabalho e a organização produtiva destas comunidades artesanais; a justiça ambiental, em seus problemas sobre a distribuição dos custos e benefícios da exploração do petróleo para essas comunidades; as memórias, tradições devocionais e histórias dos sujeitos que compõem essas comunidades; trabalhos acerca dos conflitos socioambientais que afligem essas comunidades; a produção da linguagem como patrimônio cultural e afirmação da identidade das pessoas nestas comunidades de pesca artesanal e, além disso, os pesquisadores deste Núcleo de pesquisa se dedicam ao acompanhamento das tecnologias sociais a serem desenvolvidas frente aos empreendimentos de geração de renda na cadeia produtiva da pesca artesanal.
  """
  @nucleo_b_desc """
  O Núcleo B de Pesquisas do PEA Pescarte tem em comum Pesquisas sobre os RECURSOS PESQUEIROS e a SEGURANÇA ALIMENTAR. Os pesquisadores deste núcleo tratam das cadeias produtivas do pescado, com foco em propostas e alternativas a partir do Pescarte; percebem e analisam a problemática da insegurança alimentar e a cadeia de agregação de valor na pesca artesanal; além de produzirem uma análise ecossistêmica dessa atividade econômico-social bem como estruturam linhas de análise para o desenvolvimento econômico pesqueiro a partir da aquicultura e da pesca artesanal. E, claro, essas pesquisas tratam dos seus temas a partir do acompanhamento do trabalho e ação do PEA Pescarte nos 10 municípios que são o foco deste projeto ambiental no Norte e na Região dos Lagos Fluminenses.
  """
  @nucleo_c_desc """
  O Núcleo C de Pesquisas do PEA Pescarte abarca as PESQUISAS EM SOCIABILIDADES E PARTICIPAÇÃO. Neste núcleo várias pesquisas são desenvolvidas preocupando-se com diversas questões acerca da condições urbanísticas e da apropriação do espaço pelas comunidades pesqueiras artesanais; pensando metodologias participativas e o processo da Educação Ambiental Pública; refletindo sobre os processos sociais e as novas tendências na pesca artesanal litorânea do Norte fluminense, acompanhando a inserção da comunidade pesqueira da Bacia de Campos em diferentes fóruns deliberativos e pesando a juventude e o modo de vida na pesca. Cabe lembrar que essas preocupações e análises se voltam às comunidades pesqueiras artesanais existentes nos 10 municípios que envolvem a ação do PEA Pescarte no Norte e região dos Lagos fluminenses.
  """
  @nucleo_d_desc """
  O Núcleo de Pesquisa D engloba os trabalhos que dizem respeito às “PESQUISAS CENSITÁRIAS E DE REDES”. Neste núcleo, os pesquisadores do Pescarte se preocupam com analisar acompanhar e analisar o Censo e os que vem sendo aplicado junto às comunidades de pesca artesanal e a produção de indicadores sociais desta atividade em dez municípios fluminenses. Além disso, neste núcleo são desenvolvidas pesquisas que analisam as redes de liderança da pesca artesanal nestes municípios, dando-se ênfase especial aos dados georreferenciados. Também se organizam aqui as pesquisas que estão subsidiando e dando forma e conteúdo para a Plataforma digital do PEA Pescarte.
  """

  @nucleo_a_nome "CULTURA"
  @nucleo_b_nome "RECURSOS HÍDRICOS E ALIMENTARES"
  @nucleo_c_nome "SOCIABILIDADES E PARTICIPAÇÃO"
  @nucleo_d_nome "CENSO E AFINS"

  defp insert_nucleo_pesquisa(_state, df) do
    for nucleo_pesquisa <- parse_nucleo_pesquisa(df), reduce: TRX.new() do
      trx ->
        letra = get_change(nucleo_pesquisa, :letra)
        key = String.to_atom("nucleo_pesquisa_#{letra}")
        TRX.insert(trx, key, nucleo_pesquisa)
    end
  end

  defp parse_nucleo_pesquisa(df) do
    df
    |> DF.select(~w(nucleo))
    |> DF.sort_by(nucleo)
    |> DF.filter(nucleo != "")
    |> DF.distinct(~w(nucleo))
    |> DF.rename(nucleo: "letra")
    |> DF.put(:desc, from_list([@nucleo_a_desc, @nucleo_b_desc, @nucleo_c_desc, @nucleo_d_desc]))
    |> DF.put(:nome, from_list([@nucleo_a_nome, @nucleo_b_nome, @nucleo_c_nome, @nucleo_d_nome]))
    |> DF.to_rows()
    |> Enum.map(&NucleoPesquisa.changeset/1)
  end

  defp insert_linha_pesquisa(state, df) do
    for linha_pesquisa <- parse_linha_pesquisa(df), reduce: TRX.new() do
      trx ->
        nucleo_letra = get_change(linha_pesquisa, :nucleo_pesquisa_id)
        nucleo_key = String.to_atom("nucleo_pesquisa_#{nucleo_letra}")
        numero = get_change(linha_pesquisa, :numero)
        key = String.to_atom("linha_pesquisa_#{numero}")

        if nucleo = state[nucleo_key] do
          changeset = put_change(linha_pesquisa, :nucleo_pesquisa_id, nucleo.id)
          TRX.insert(trx, key, changeset)
        else
          TRX.insert(trx, key, linha_pesquisa)
        end
    end
  end

  defp parse_linha_pesquisa(df) do
    df
    |> DF.select(~w(nucleo linha_pesquisa linha_pesquisa_numero))
    |> DF.rename(linha_pesquisa: "desc_curta")
    |> DF.rename(linha_pesquisa_numero: "numero")
    |> DF.rename(nucleo: "nucleo_pesquisa_id")
    |> DF.to_rows()
    |> Enum.uniq_by(& &1["numero"])
    |> Enum.map(&LinhaPesquisa.changeset/1)
  end

  defp insert_campus(_state, data) do
    for campus <- parse_campus(data), reduce: TRX.new() do
      trx ->
        acronimo = get_change(campus, :acronimo)
        key = String.to_atom("campus_#{acronimo}")
        TRX.insert(trx, key, campus)
    end
  end

  defp parse_campus(data) do
    data
    |> DF.select(~w(campus campus_endereco nome_universidade acronimo))
    |> DF.rename(campus: "nome")
    |> DF.rename(campus_endereco: "endereco")
    |> DF.to_rows()
    |> Enum.uniq_by(& &1["acronimo"])
    |> Enum.reject(&(&1["acronimo"] == ""))
    |> Enum.map(&Campus.changeset/1)
  end

  @senha_default "@peaSenha123!@"

  defp insert_usuario(_state, data) do
    for usuario <- parse_usuario(data), reduce: TRX.new() do
      trx ->
        primeiro_nome = usuario["primeiro_nome"]
        cpf = usuario["cpf"]
        key = String.to_atom("usuario_#{cpf}")
        contato = usuario["contato"]
        contato_key = String.to_atom("contato_#{primeiro_nome}_#{cpf}}")
        supabase_key = String.to_atom("supabase_user_#{cpf}")

        trx
        |> TRX.insert(contato_key, fn _ -> Contato.changeset(contato) end)
        |> TRX.run(supabase_key, fn _repo, state ->
          contato = state[contato_key]

          app_metadata = Map.drop(usuario, ~w(endereco ativo? telefone email))

          Map.new()
          |> Map.put("email", contato.email_principal)
          |> Map.put("phone", contato.celular_principal)
          |> Map.update!("phone", &String.replace(&1, ~r/\D/, ""))
          |> Map.put("password", @senha_default)
          |> Map.put("phone_confirm", true)
          |> Map.put("role", "pesquisador")
          |> Map.put("app_metadata", app_metadata)
          |> then(fn attrs ->
            {:ok, client} = Pescarte.get_supabase_client()
            Supabase.GoTrue.Admin.create_user(client, attrs)
          end)
        end)
        |> TRX.run(key, fn _repo, state ->
          contato = state[contato_key]
          supabase_user = state[supabase_key]

          usuario
          |> Map.put("contato_id", contato.id)
          |> Map.put("link_avatar", usuario["link_foto"])
          |> Map.put("external_customer_id", "supabase|" <> supabase_user.id)
          |> Map.merge(%{"senha" => @senha_default, "senha_confirmation" => @senha_default})
          |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
          |> RegisterUsuario.run(:pesquisador)
        end)
    end
  end

  @usuario_columns ~w(primeiro_nome sobrenome data_nascimento endereco ativo? cpf rg email telefone link_foto nome_completo)

  def parse_usuario(df) do
    df
    |> DF.select(@usuario_columns)
    |> DF.put(:ativo?, transform(df["ativo?"], &(&1 == "S")))
    |> DF.put(:data_nascimento, transform(df["data_nascimento"], &parse_date/1))
    |> DF.to_rows()
    |> Enum.map(fn usuario ->
      Map.update!(usuario, "endereco", &String.trim(&1))
    end)
    |> Enum.map(fn usuario ->
      Map.update!(usuario, "cpf", &String.replace(&1, ~r/\D/, ""))
    end)
    |> Enum.uniq_by(& &1["cpf"])
    |> Enum.reject(&(!Brcpfcnpj.cpf_valid?(&1["cpf"])))
    |> Enum.map(&maybe_explode_emails/1)
    |> Enum.map(&maybe_explode_telefones/1)
    |> Enum.map(&make_contato/1)
  end

  defp parse_date(""), do: nil

  defp parse_date(<<day::binary-size(2), "/", month::binary-size(2), "/", year::binary-size(4)>>) do
    integer_day = String.to_integer(day)
    integer_month = String.to_integer(month)
    integer_year = String.to_integer(year)

    Date.new!(integer_year, integer_month, integer_day)
  end

  defp maybe_explode_emails(params) do
    params["email"]
    |> String.replace(~r/[\s,;]+/, ";")
    |> String.split(";", trim: true)
    |> then(fn
      [principal | emails] ->
        params
        |> Map.put("email_principal", principal)
        |> Map.put("emails_adicionais", emails)

      [] ->
        Map.put(params, "email_principal", params["email"])
    end)
  end

  defp maybe_explode_telefones(params) do
    ~r/\(?(\d{2})\)?\s*(\d{4,5}\-?\d{4})/
    |> Regex.scan(params["telefone"], capture: :all_but_first)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.map(&String.replace(&1, ~r/\D/, ""))
    |> then(fn
      [principal | telefones] ->
        params
        |> Map.put("celular_principal", principal)
        |> Map.put("celulares_adicionais", telefones)

      [] ->
        Map.put(params, "celular_principal", params["telefone"])
    end)
  end

  @contato_fields ~w(email_principal emails_adicionais celular_principal celulares_adicionais endereco)

  defp make_contato(params) do
    contato = Map.take(params, @contato_fields)

    params
    |> Map.drop(@contato_fields)
    |> Map.put("contato", contato)
  end

  defp insert_pesquisador(state, data) do
    for pesquisador <- parse_pesquisador(data), reduce: TRX.new() do
      trx ->
        cpf = get_change(pesquisador, :usuario_id)
        usuario_key = String.to_atom("usuario_#{cpf}")
        usuario = state[usuario_key]

        unless usuario, do: inspect(pesquisador)

        acronimo = get_change(pesquisador, :campus_id)
        campus_key = String.to_atom("campus_#{acronimo}")
        campus = state[campus_key]

        key = String.to_atom("pesquisador_#{cpf}")
        pesquisador = put_change(pesquisador, :usuario_id, usuario.id)
        pesquisador = put_change(pesquisador, :campus_id, campus.id)

        TRX.insert(trx, key, pesquisador)
    end
  end

  @pesquisador_columns ~w(cpf link_lattes formacao data_inicio_bolsa data_fim_bolsa data_contratacao acronimo bolsa responsavel? orientacao minibio)

  defp parse_pesquisador(df) do
    df
    |> DF.select(@pesquisador_columns)
    |> DF.rename(cpf: "usuario_id")
    |> DF.rename(acronimo: "campus_id")
    |> DF.put(:bolsa, transform(df["bolsa"], &parse_tipo_bolsa/1))
    |> DF.put(:data_inicio_bolsa, transform(df["data_nascimento"], &parse_date/1))
    |> DF.put(:data_fim_bolsa, transform(df["data_nascimento"], &parse_date/1))
    |> DF.put(:data_contratacao, transform(df["data_nascimento"], &parse_date/1))
    |> DF.to_rows()
    |> Enum.map(fn usuario ->
      Map.update!(usuario, "usuario_id", &String.replace(&1, ~r/\D/, ""))
    end)
    |> Enum.uniq_by(& &1["usuario_id"])
    |> Enum.map(&Pesquisador.changeset/1)
  end

  defp parse_tipo_bolsa("Consultoria"), do: "consultoria"
  defp parse_tipo_bolsa("Coordenador Pedagógico"), do: "coordenador_pedagogico"
  defp parse_tipo_bolsa("Coordenador Técnico"), do: "coordenador_tecnico"
  defp parse_tipo_bolsa("Doutorado"), do: "doutorado"
  defp parse_tipo_bolsa("Mestrado"), do: "mestrado"
  defp parse_tipo_bolsa("Iniciação Científica"), do: "ic"
  defp parse_tipo_bolsa("Pesquisador"), do: "pesquisa"
  defp parse_tipo_bolsa("Pesquisadora"), do: "pesquisa"
  defp parse_tipo_bolsa("Pós Doutorado"), do: "pos_doutorado"
  defp parse_tipo_bolsa("NSA"), do: "nsa"
  defp parse_tipo_bolsa(_), do: "desconhecido"

  defp insert_pesquisador_lp(state, df) do
    for params <- parse_pesquisador_lp(df), reduce: TRX.new() do
      trx ->
        cpf = params["cpf"]
        pesquisador_key = String.to_atom("pesquisador_#{cpf}")
        pesquisador = state[pesquisador_key]

        responsavel = params["responsavel?"]
        numero = params["linha_pesquisa_numero"]
        linha_pesquisa_key = String.to_atom("linha_pesquisa_#{numero}")
        linha_pesquisa = state[linha_pesquisa_key]

        key = String.to_atom("pesquisador_linha_pesquisa_#{cpf}_#{numero}")

        pesquisador_lp =
          params
          |> Map.put("pesquisador_id", pesquisador.id)
          |> Map.put("linha_pesquisa_id", linha_pesquisa.id)

        cond do
          responsavel == "" ->
            pesquisador_lp = Map.put(pesquisador_lp, "lider?", false)
            TRX.insert(trx, key, fn _ -> PesquisadorLP.changeset(pesquisador_lp) end)

          String.to_integer(responsavel) == numero ->
            pesquisador_lp = Map.put(pesquisador_lp, "lider?", true)
            TRX.insert(trx, key, fn _ -> PesquisadorLP.changeset(pesquisador_lp) end)

          String.to_integer(responsavel) != numero ->
            # linha que pertence
            pesquisador_lp = Map.put(pesquisador_lp, "lider?", false)
            TRX.insert(trx, key, fn _ -> PesquisadorLP.changeset(pesquisador_lp) end)
        end
    end
  end

  defp parse_pesquisador_lp(df) do
    df
    |> DF.select(~w(cpf linha_pesquisa_numero responsavel?))
    |> DF.to_rows()
    |> Enum.map(fn usuario ->
      Map.update!(usuario, "cpf", &String.replace(&1, ~r/\D/, ""))
    end)
  end
end
