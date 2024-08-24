defmodule PescarteWeb.DesignSystem.GetInTouch do
  use PescarteWeb, :component

  def render(assigns) do
    ~H"""
    <div class="onde-nos-encontrar-wrapper">
      <.text size="h1" color="text-white-100">Onde nos Encontrar</.text>
      <div class="redes-sociais-wrapper">
        <.text size="h4" color="text-white-100">
          Estamos presentes nas redes sociais!
        </.text>
        <.text size="h4" color="text-white-100">
          Clique nos botões abaixo para visitar nossos perfis.
        </.text>
        <div class="redes-sociais-links-wrapper">
          <div class="redes-sociais-link">
            <DesignSystem.link target-blank navigate="https://www.facebook.com/peapescarte">
              <div class="redes-sociais-icon">
                <Lucideicons.facebook />
              </div>
            </DesignSystem.link>
            <.text size="h4" color="text-white-100">Facebook</.text>
          </div>
          <div class="redes-sociais-link">
            <DesignSystem.link
              target-blank
              navigate="https://www.instagram.com/peapescarte/?img_index=1"
            >
              <div class="redes-sociais-icon">
                <Lucideicons.instagram />
              </div>
            </DesignSystem.link>
            <.text size="h4" color="text-white-100">Instagram</.text>
          </div>
          <div class="redes-sociais-link">
            <DesignSystem.link target-blank navigate="https://www.youtube.com/PEAPescarte">
              <div class="redes-sociais-icon">
                <Lucideicons.youtube />
              </div>
            </DesignSystem.link>
            <.text size="h4" color="text-white-100">Youtube</.text>
          </div>
        </div>
      </div>
      <div class="fale-conosco-wrapper">
        <.text size="h3" color="text-white-100">
          Mas, se preferir, entre em contato diretamente.
        </.text>
        <DesignSystem.link href="/contato" class="contact-btn">
          <Lucideicons.message_square />Clique Para Expandir
        </DesignSystem.link>
      </div>
    </div>
    """
  end
end
