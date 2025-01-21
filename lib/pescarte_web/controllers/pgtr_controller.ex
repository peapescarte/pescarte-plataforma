defmodule PescarteWeb.PGTRController do
  use PescarteWeb, :controller

  alias Pescarte.Municipios
  alias Pescarte.Municipios.{Unit, Document, DocumentType}

  # Aplicar plugs de autenticação/autorização em ações específicas
  plug :authenticate_user
       when action in [
         :create_municipio,
         :update_municipio,
         :create_unit,
         :update_unit,
         :create_document_type,
         :update_document_type,
         :create_document,
         :update_document
       ]

  plug :authorize_admin
       when action in [
         :create_municipio,
         :update_municipio,
         :create_unit,
         :update_unit,
         :create_document_type,
         :update_document_type,
         :create_document,
         :update_document
       ]

  @doc """
  Exibe a página principal de PGTR, listando municípios, unidades, etc.
  """
  def show(conn, _params) do
    # Buscar tudo que o template precisa, já com preload
    municipios = Municipios.list_municipio()
    units = Municipios.list_units()
    document_types = Municipios.list_document_types()
    documents = Municipios.list_documents()

    # Changesets para formulários
    unit_changeset = Municipios.change_unit(%Unit{})
    document_changeset = Municipios.change_document(%Document{})
    document_type_changeset = Municipios.change_document_type(%DocumentType{})

    # Lista de status possíveis
    statuses = [
      %{key: :concluido, label: "Concluído"},
      %{key: :pendente, label: "Pendente"},
      %{key: :em_andamento, label: "Em andamento"}
    ]

    assigns = %{
      municipios: municipios,
      units: units,
      document_types: document_types,
      documents: documents,
      unit_changeset: unit_changeset,
      document_changeset: document_changeset,
      document_type_changeset: document_type_changeset,
      statuses: statuses,
      current_path: conn.request_path,
      current_user: conn.assigns[:current_user],
      error_message: nil
    }

    render_show(conn, assigns)
  end

  # -----------------------------------------------------------------
  # CRUD de MUNICIPIOS
  # -----------------------------------------------------------------
  def create_municipio(conn, %{"municipio" => municipio_params}) do
    current_user_id = get_current_user_id(conn)
    municipio_params = Map.put(municipio_params, "created_by", current_user_id)

    case Municipios.create_municipio(municipio_params) do
      {:ok, _municipio} ->
        conn
        |> put_flash(:info, "Município criado com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        render_show(conn, %{municipio_changeset: changeset})
    end
  end

  def update_municipio(conn, %{"id" => id, "municipio" => municipio_params}) do
    municipio = Municipios.get_municipio!(id)
    current_user_id = get_current_user_id(conn)
    municipio_params = Map.put(municipio_params, "updated_by", current_user_id)

    case Municipios.update_municipio(municipio, municipio_params) do
      {:ok, _municipio} ->
        conn
        |> put_flash(:info, "Município atualizado com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        render_show(conn, %{municipio_changeset: changeset})
    end
  end

  # -----------------------------------------------------------------
  # CRUD de UNIDADES
  # -----------------------------------------------------------------
  def create_unit(conn, %{"unit" => unit_params}) do
    current_user_id = get_current_user_id(conn)
    unit_params = Map.put(unit_params, "created_by", current_user_id)

    case Municipios.create_unit(unit_params) do
      {:ok, _unit} ->
        conn
        |> put_flash(:info, "Unidade criada com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        render_show(conn, %{unit_changeset: changeset})
    end
  end

  def update_unit(conn, %{"unit" => unit_params}) do
    unit = Municipios.get_unit!(unit_params["id"])
    current_user_id = get_current_user_id(conn)
    unit_params = Map.put(unit_params, "updated_by", current_user_id)

    case Municipios.update_unit(unit, unit_params) do
      {:ok, _unit} ->
        conn
        |> put_flash(:info, "Unidade atualizada com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        render_show(conn, %{unit_changeset: changeset})
    end
  end

  # -----------------------------------------------------------------
  # CRUD de TIPOS DE DOCUMENTO (DOCUMENT_TYPE)
  # -----------------------------------------------------------------
  def create_document_type(conn, %{"document_type" => dt_params}) do
    current_user_id = get_current_user_id(conn)
    dt_params = Map.put(dt_params, "created_by", current_user_id)

    case Municipios.create_document_type(dt_params) do
      {:ok, _doc_type} ->
        conn
        |> put_flash(:info, "Tipo de Documento criado com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        render_show(conn, %{document_type_changeset: changeset})
    end
  end

  def update_document_type(conn, %{"id" => id, "document_type" => dt_params}) do
    document_type = Municipios.get_document_type!(id)
    current_user_id = get_current_user_id(conn)
    dt_params = Map.put(dt_params, "updated_by", current_user_id)

    case Municipios.update_document_type(document_type, dt_params) do
      {:ok, _doc_type} ->
        conn
        |> put_flash(:info, "Tipo de Documento atualizado com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        render_show(conn, %{document_type_changeset: changeset})
    end
  end

  # -----------------------------------------------------------------
  # CRUD de DOCUMENTOS
  # -----------------------------------------------------------------
  def create_document(conn, %{"document" => document_params}) do
    current_user_id = get_current_user_id(conn)
    document_params = Map.put(document_params, "created_by", current_user_id)

    case Municipios.create_document(document_params) do
      {:ok, _document} ->
        conn
        |> put_flash(:info, "Documento criado com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        render_show(conn, %{document_changeset: changeset})
    end
  end

  def update_document(conn, %{"id" => id, "document" => document_params}) do
    document = Municipios.get_document!(id)
    current_user_id = get_current_user_id(conn)
    document_params = Map.put(document_params, "updated_by", current_user_id)

    case Municipios.update_document(document, document_params) do
      {:ok, _document} ->
        conn
        |> put_flash(:info, "Documento atualizado com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        render_show(conn, %{document_changeset: changeset})
    end
  end

  # -----------------------------------------------------------------
  # Funções Auxiliares e Plugs de Autorização
  # -----------------------------------------------------------------
  defp get_current_user_id(conn_or_socket) do
    user =
      case conn_or_socket do
        %Plug.Conn{} -> conn_or_socket.assigns[:current_user]
        %Phoenix.LiveView.Socket{} -> conn_or_socket.assigns[:current_user]
      end

    user && user.id
  end

  defp authenticate_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "Você precisa estar logado para acessar essa página.")
      |> redirect(to: ~p"/acessar")
      |> halt()
    end
  end

  defp authorize_admin(conn, _opts) do
    user = conn.assigns[:current_user]

    if user && user.papel == :admin do
      conn
    else
      conn
      |> put_flash(:error, "Você não tem permissão para realizar esta ação.")
      |> redirect(to: ~p"/pgtr")
      |> halt()
    end
  end

  # Render auxiliar para a página show
  defp render_show(conn, additional_assigns) do
    current_path = conn.request_path

    # Sempre buscamos dados atualizados aqui
    municipios = Municipios.list_municipio()
    units = Municipios.list_units()
    document_types = Municipios.list_document_types()
    documents = Municipios.list_documents()

    unit_changeset = Municipios.change_unit(%Unit{})
    document_changeset = Municipios.change_document(%Document{})
    document_type_changeset = Municipios.change_document_type(%DocumentType{})

    statuses = [
      %{key: :concluido, label: "Concluído"},
      %{key: :pendente, label: "Pendente"},
      %{key: :em_andamento, label: "Em andamento"}
    ]

    # Assigns padrão
    assigns = %{
      municipios: municipios,
      units: units,
      document_types: document_types,
      documents: documents,
      unit_changeset: unit_changeset,
      document_changeset: document_changeset,
      document_type_changeset: document_type_changeset,
      statuses: statuses,
      current_path: current_path,
      current_user: conn.assigns.current_user,
      error_message: nil
    }

    # Mesclamos com os assigns adicionais (por ex., changeset de erro)
    assigns = Map.merge(assigns, additional_assigns)

    render(conn, :show, assigns)
  end
end
