defmodule PlataformaDigital.CadastroHTML do
  use PlataformaDigital, :html

  def show(assigns) do
    assigns = Map.put(assigns, :form, to_form(%{}, as: :user))
    ~H"""
    <div class="buttons-wrapper">
     <.button
        name="save"
        value="save-cadastro"
        style="primary"    phx-disable-with="Salvando….."
        submit
        disabled={not @form.source.valid?}
     >
           <Lucideicons.save /> Salvar respostas
     </.button>
     <.button
            name="save"       value="send-cadastro"
            style="primary"    phx-disable-with="Enviando..."
            submit                 disabled={not @form.source.valid?}
          >
            <Lucideicons.send /> Enviar cadastro
          </.button>
        </div>

      """
  end
end
