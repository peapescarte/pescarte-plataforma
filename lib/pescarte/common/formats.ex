defmodule Pescarte.Common.Formats do
  @moduledoc """
  Our common place for formats
  """

  @email_regex ~r/^[^\s]+@[^\s]+$/
  @cpf_format ~r/^\d{3}\.\d{3}\.\d{3}\-\d{2}$/
  @cnpj_format ~r/^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/
  @rg_format ~r/^\d{2}\.\d{3}\.\d{3}\-\d{1}$/
  @mobile_format ~r/^\(\d{2}\)(\d{5}|\s\d{5})-\d{4}$/

  @spec email :: Regex.t()
  def email, do: @email_regex
  @spec cpf :: Regex.t()
  def cpf, do: @cpf_format
  @spec rg :: Regex.t()
  def rg, do: @rg_format
  @spec cnpj :: Regex.t()
  def cnpj, do: @cnpj_format
  @spec mobile :: Regex.t()
  def mobile, do: @mobile_format
end
