defmodule QRClassWeb.ClassSessionLive.Index do
  alias QRClass.Course
  use QRClassWeb, :live_view

  def mount(params, _, socket) do
    {:ok,
     assign(socket,
       class_session:
         Course.get_class_session(params["id"], [:attendances, class: :students]) |> IO.inspect()
     )}
  end

  def handle_event("change-attendance", %{"student-id" => student_id} = params, socket) do
    attendance = Course.get_attendance(student_id, socket.assigns.class_session.id)

    if params["value"] == "on" do
      Course.register_presence(attendance)
    else
      Course.remove_presence(attendance)
    end

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      <%= @class_session.class.name %> - <%= format_date(@class_session.start_date) %>
    </.header>

    <div class="text-center text-lg mt-6">
      Alunos
    </div>

    <.table id="classes" rows={@class_session.class.students}>
      <:col :let={student} label="E-mail">
        <span class="font-normal"><%= student.email %></span>
      </:col>

      <:col :let={student} label="Presença">
        <label class="flex items-center relative w-max cursor-pointer select-none">
          <input
            type="checkbox"
            checked={Enum.find(@class_session.attendances, &(&1.student_id == student.id)).attended}
            phx-click="change-attendance"
            phx-value-student-id={student.id}
            style="background-image: none; color: rgb(34, 197, 94)"
            class="peer appearance-none transition-colors cursor-pointer w-14 h-7 rounded-full focus:outline-none focus:ring-0 focus:ring-offset-0 bg-red-500 bg-gre"
          />
          <span class="peer-checked:translate-x-7 w-7 h-7 right-7 absolute rounded-full transform transition-transform bg-gray-200" />
        </label>
      </:col>
    </.table>

    <.back navigate={~p"/classes/#{@class_session.class}"}>Voltar</.back>
    """
  end
end
