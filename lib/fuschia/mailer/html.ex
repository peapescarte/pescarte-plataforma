defmodule Fuschia.Mailer.HTML do
  @moduledoc false

  @doc """
  Injete os valores `assigns` nas tags .eex do modelo `email`
  do "homologacao" ou "financiamento" `projeto` e então renderizar
  a página HTML resultante em um modelo base.
  Retorna uma página HTML em formato de string.
  """
  @spec assemble_body(binary, String.t(), map, String.t()) :: any
  def assemble_body(project, email, assigns, base \\ "base") when is_map(assigns) do
    assigns
    |> rewrite_name()
    |> rewrite_email_address()
    |> render_email(project, email)
    |> render_layout(base)
  end

  @spec templates_path :: binary
  def templates_path, do: "#{:code.priv_dir(:fuschia)}/templates"

  defp pea_pescarte_contact do
    :fuschia
    |> Application.get_env(:pea_pescarte_contact)
    |> Map.new()
  end

  defp rewrite_name(%{user_nome_completo: name} = assigns), do: Map.put(assigns, :nome, name)
  defp rewrite_name(%{nome: name} = assigns), do: Map.put(assigns, :nome, name)
  defp rewrite_name(assigns), do: Map.put(assigns, :nome, "")

  defp rewrite_email_address(%{email: email} = assigns), do: Map.put(assigns, :email, email)
  defp rewrite_email_address(assigns), do: Map.put(assigns, :email, "")

  defp render_email(assigns, project, email) do
    EEx.eval_file("#{templates_path()}/email/#{project}/#{email}.html.eex",
      assigns: assigns,
      pea_pescarte: pea_pescarte_contact()
    )
  end

  defp render_layout(inner_content, nil), do: render_layout(inner_content, "base")

  defp render_layout(inner_content, base) do
    EEx.eval_file("#{templates_path()}/layout/#{base}.html.eex",
      assigns: [inner_content: inner_content]
    )
  end
end
