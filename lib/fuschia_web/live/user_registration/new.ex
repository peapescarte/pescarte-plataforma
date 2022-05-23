defmodule FuschiaWeb.UserRegistrationLive.New do
  @moduledoc false

  use FuschiaWeb, :live_view

  import FuschiaWeb.Gettext

  alias Fuschia.Accounts
  alias Fuschia.Accounts.Models.User
  alias FuschiaWeb.UserAuth
  alias Surface.Components.Form
  alias Surface.Components.Form.{EmailInput, Field, Label, PasswordInput}

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})
    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("validate", %{"user_model" => user_params}, socket) do
    changeset =
      %User{}
      |> Accounts.change_user_registration(user_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user_model" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, user} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(socket, :edit, &1)
          )

        {:noreply,
         socket
         |> put_flash(:info, dgettext("info", "Registration went successfully"))
         |> UserAuth.log_in_user(user)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
