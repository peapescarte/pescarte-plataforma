defmodule FuschiaJobs.MailerJobTest do
  use Fuschia.DataCase
  use Oban.Testing, repo: Fuschia.Repo

  import ExUnit.CaptureLog

  alias Fuschia.Jobs.MailerJob

  describe "perform/1" do
    test "successfully execute mailer job" do
      args = %{
        to: "test_user@gmail.com",
        subject: "some subject",
        layout: "user",
        template: "confirmation",
        assigns: %{name: "Juninho testinho", link: "https://teste-peapescarte.uenf.br/confirm"},
        base: "base",
        bcc: []
      }

      assert :ok == perform_job(MailerJob, args)
    end

    test "failure execute mailer job" do
      args = %{bad: :arg}

      assert capture_log(fn ->
               perform_job(MailerJob, args)
             end) =~ "Mailer.new_email(nil, nil, nil, nil, nil, nil, nil)"
    end
  end
end
