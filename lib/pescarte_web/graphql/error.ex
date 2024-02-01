defmodule PescarteWeb.GraphQL.Error do
  require Logger
  alias __MODULE__

  @fields ~w(code message status_code key)a

  @enforce_keys ~w(code message status_code)a
  defstruct @fields

  def normalize(err) do
    handle(err)
  end

  # Suporte para diferentes Erros
  # -----------------------------

  defp handle(errors) when is_list(errors) do
    Enum.map(errors, &handle/1)
  end

  defp handle(code) when is_atom(code) do
    {status, message} = metadata(code)

    %Error{code: code, message: message, status_code: status}
  end

  defp handle(%Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {err, _opts} -> err end)
    |> Enum.map(fn {key, error} ->
      %Error{
        code: :validation,
        message: error,
        status_code: 422,
        key: key
      }
    end)
  end

  defp handle(other) do
    Logger.error("Unhandled error term:\n#{inspect(other)}")
    handle(:unknown)
  end

  # Metadata
  # --------

  defp metadata(:unauthenticated), do: {401, "Você precisa ter feito login"}
  defp metadata(:invalid_credentials), do: {401, "Credenciais inválidas"}
  defp metadata(:unauthorized), do: {403, "Você não possui permissões para acessar"}
  defp metadata(:not_found), do: {404, "Recurso não encontrado"}
  defp metadata(:unknown), do: {500, "Algo deu errado"}

  defp metadata(code) do
    Logger.warning("Unhandled error code: #{inspect(code)}")
    {422, to_string(code)}
  end
end
