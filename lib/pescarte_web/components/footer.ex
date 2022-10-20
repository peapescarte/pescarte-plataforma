defmodule PescarteWeb.Components.Footer do
  @moduledoc false

  use PescarteWeb, :component

  def render(assigns) do
    ~H"""
    <footer class="footer footer-center p-4 bg-white">
      <img src="/images/footer_logo.png" alt={alt_text()} class="w-2/5" />
    </footer>
    """
  end

  def alt_text do
    """
    Bloco de logos das instiuições relacionadas
    ao projeto Pescarte: IPEAD; UENF; Petrobras;
    e Ibama.
    """
  end
end
