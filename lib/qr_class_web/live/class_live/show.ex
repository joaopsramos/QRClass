defmodule QRClassWeb.ClassLive.Show do
  use QRClassWeb, :live_view

  alias QRClass.Course

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, class_session: nil)}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    {:noreply,
     assign(socket,
       page_title: "Class Sessions",
       class: Course.get_class!(id),
       class_session:
         params["class_session_id"] && Course.get_class_session(params["class_session_id"]),
       class_sessions: Course.list_class_sessions_by_class_id(id)
     )}
  end
end
