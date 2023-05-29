defmodule QRClassWeb.AttendanceLive.Index do
  alias QRClass.Course
  alias QRClass.Accounts
  use QRClassWeb, :live_view

  def mount(params, _, socket) do
    {:ok, assign(socket, token: params["token"], registered: false)}
  end

  def handle_event("register", %{"attendance" => %{"email" => email}}, socket) do
    socket =
      with {:ok, class_session_id} <- validate_token(socket.assigns.token),
           {:ok, class_session} <- validate_class_session(class_session_id),
           {:ok, user} <- validate_user(email),
           {:ok, attendance} <- validate_attendance(user, class_session),
           {:ok, _} <- register_presence(attendance) do
        socket
        |> assign(registered: true)
        |> put_flash(:info, "Presença registrada com sucesso")
      else
        {:error, reason} -> put_flash(socket, :error, reason)
      end

    {:noreply, socket}
  end

  defp validate_token(token) do
    case Base.decode64(token) do
      {:ok, class_session_id} -> {:ok, class_session_id}
      :error -> {:error, "Erro ao validar QR Code"}
    end
  end

  defp validate_class_session(class_session_id) do
    if class_session = Course.get_class_session(class_session_id) do
      if class_session.qr_code_active do
        {:ok, class_session}
      else
        {:error,
         "Não é mais possivel registrar presença nesta aula, se você acha que isso é um problema, comunique seu professor"}
      end
    else
      {:error, "Aula não encontrada, comunique seu professor"}
    end
  end

  defp validate_user(email) do
    if user = Accounts.get_user_by_email(email) do
      {:ok, user}
    else
      {:error, "E-mail não encontrado"}
    end
  end

  defp validate_attendance(user, class_session) do
    case Course.get_attendance(user.id, class_session.id) do
      nil ->
        {:error,
         "Aluno não encontrado nesta aula, verifique o e-mail informado, se o problema persistir, comunique o professor"}

      attendance ->
        {:ok, attendance}
    end
  end

  defp register_presence(attendance) do
    case Course.register_presence(attendance) do
      {:error, _} -> {:error, "Erro ao registrar presença, por favor comunique seu professor"}
      ok_attendance -> ok_attendance
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-md mx-auto flex flex-col items-center">
      <div :if={@registered}>
        <h2 class="text-center font-semibold text-2xl front-bold mt-24">
          Tudo certo! Você já pode fechar essa aba
        </h2>
      </div>

      <div :if={not @registered}>
        <h2 class="text-2xl font-bold mt-24">Registrar presença</h2>

        <.form
          :let={f}
          for={%{}}
          as={:attendance}
          phx-submit="register"
          class="flex flex-col items-center mt-16"
        >
          <.input field={f[:email]} label="E-mail" />

          <button class="text-white font-semibold py-2 px-3 rounded-lg bg-green-500 hover:bg-green-700 mt-4 w-full">
            Registrar
          </button>
        </.form>
      </div>
    </div>
    """
  end
end
