defmodule QRClassWeb.TeacherLive.Index do
  use QRClassWeb, :live_view

  alias QRClass.Accounts
  alias QRClass.Course

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    {:ok, assign(socket, classes: Course.get_teacher_classes(user.id))}
  end
end
