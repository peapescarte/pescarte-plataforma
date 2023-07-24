defmodule Database.Types.PublicId do
  @moduledoc """
  Módulo responsável por gerar automaticamente um id público
  para entidades que forem ser expostas via API ou plataforma web.

  Para usar, basta adicionar no schema:
      field :id_publico, PublicId
  """

  use Ecto.Type

  @impl true
  def type, do: :string

  @impl true
  def cast(nano_id), do: {:ok, nano_id}

  @impl true
  def dump(nano_id), do: {:ok, nano_id}

  @impl true
  def load(nano_id), do: {:ok, nano_id}

  @impl true
  def autogenerate, do: Nanoid.generate()
end
