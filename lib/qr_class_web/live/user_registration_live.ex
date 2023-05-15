defmodule QRClassWeb.UserRegistrationLive do
  use QRClassWeb, :live_view

  alias QRClass.Accounts
  alias QRClass.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Criar conta
        <:subtitle>
          Já possui uma?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Clique aqui
          </.link>
          para fazer log in.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, algo deu errado! Por favor confira os erros abaixo.
        </.error>

        <div class="flex">
          <label
            id="student-label"
            class={"py-2 basis-0 flex-auto border rounded-l-full text-right hover:text-brand #{@selected_user_type_class}"}
            phx-click={
              JS.add_class(@selected_user_type_class)
              |> JS.remove_class(@selected_user_type_class, to: "#teacher-label")
            }
          >
            <span class="pr-4">Aluno</span>
            <input
              type="radio"
              name={@form[:type].name}
              id={@form[:type].id <> "student"}
              value={User.student()}
              class="hidden"
              checked={(@form[:type].value || User.student()) == User.student()}
            />
          </label>
          <label
            id="teacher-label"
            class="py-2 basis-0 flex-auto border rounded-r-full hover:text-brand"
            phx-click={
              JS.add_class(@selected_user_type_class)
              |> JS.remove_class(@selected_user_type_class, to: "#student-label")
            }
          >
            <span class="pl-4">Professor</span>
            <input
              type="radio"
              name={@form[:type].name}
              id={@form[:type].id <> "teacher"}
              value={User.teacher()}
              class="hidden"
              checked={@form[:type].value == User.teacher()}
            />
          </label>
        </div>

        <.input field={@form[:email]} type="email" label="Email" required phx-debounce="300" />
        <.input field={@form[:password]} type="password" label="Senha" required phx-debounce="300" />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Criar conta</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(
        trigger_submit: false,
        check_errors: false,
        selected_user_type_class: "text-white bg-black hover:text-white",
        unselected_user_type_class: "text-black bg-white hover:text-brand"
      )
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)

    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
