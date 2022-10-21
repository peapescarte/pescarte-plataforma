defmodule BackendJobs.MailerJobTest do
  use Backend.DataCase
  use Oban.Testing, repo: Backend.Repo

  import ExUnit.CaptureLog

  alias Backend.Jobs.MailerJob

  @moduletag :integration

  describe "perform/1" do
    test "successfully execute mailer job" do
      args = %{
        to: "test_user@gmail.com",
        subject: "some subject",
        layout: "user",
        template: "confirmation",
        assigns: %{name: "Juninho testinho", link: "https://teste-peabackend.uenf.br/confirm"},
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
