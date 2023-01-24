defmodule Pescarte.Domains.ModuloPesquisa.Models.Campus do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Cidade
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Types.TrimmedString

  schema "campus" do
    field :name, TrimmedString
    field :initials, TrimmedString
    field :public_id, :string

    has_many :pesquisadors, Pesquisador
    belongs_to :cidade, Cidade, on_replace: :delete

    timestamps()
  end
end
