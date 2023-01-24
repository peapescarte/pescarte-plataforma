defmodule Pescarte.MailerTest.GenerateTests do
  defmacro __using__(_opts) do
    quote do
      use ExUnit.Case

      alias Pescarte.{Mailer, MailerTest}
      alias Swoosh.Email

      @general_assigns %{
        id: "1",
        link: "http://link.dev",
        comentario: "Esse é um comentário",
        user_nome_completo: "Usuário Joaozinho",
        user_contato_email: "joaozinho@contato.com",
        endereco_street: "Av. Paulista, 9876",
        endereco_neighborhood: "Bela Vista",
        endereco_cep: "01310-100",
        endereco_cidade: "São Paulo",
        endereco_state: "SP"
      }

      for project <- ["user"] do
        for email <- MailerTest.GenerateTests.emails(project) do
          @tag email: email, project: project
          test ~s(new_email/7 in #{project} using #{email} template returns an email structure),
               %{email: email, project: project} do
            assert(
              %Email{} = Mailer.new_email(nil, nil, project, email, @general_assigns, "base", nil)
            )
          end
        end
      end
    end
  end

  @spec emails(binary) :: list(String.t())
  def emails(project) do
    template_path = "#{:code.priv_dir(:pescarte)}/templates"
    path = Path.expand("#{template_path}/email/#{project}", __DIR__)

    (path <> "/*")
    |> Path.wildcard()
    |> Enum.map(&String.replace(&1, [path <> "/", ".html.eex"], ""))
  end
end

defmodule Pescarte.MailerTest do
  use Pescarte.MailerTest.GenerateTests

  alias Pescarte.Mailer

  @moduletag :unit

  test "add_attachment/2 always returns the email structure" do
    assert %Email{} =
             nil
             |> Mailer.new_email(nil, "user", "confirmation", @general_assigns)
             |> Mailer.add_attachment("")
  end
end
