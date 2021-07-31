defmodule Fuschia.Common.Formats do
  @moduledoc """
  Our common place for formats
  """

  @cpf_format ~r/^\d{3}\.\d{3}\.\d{3}\-\d{2}$/
  @cnpj_format ~r/^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/
  @rg_format ~r/^\d{2}\.\d{3}\.\d{3}\-\d{1}$/
  @mobile_format ~r/^\(\d{2}\)(\d{5}|\s\d{5})-\d{4}$/
  @cep_format ~r/^\d{5}\-\d{3}$/
  @email_format ~r/^[^\s]+@[^\s]+$/

  def cpf, do: @cpf_format
  def rg, do: @rg_format
  def cnpj, do: @cnpj_format
  def mobile, do: @mobile_format
  def email, do: @email_format
end
