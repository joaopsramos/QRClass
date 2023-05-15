defmodule QRClassWeb.TeacherController do
  use QRClassWeb, :controller

  alias QRClass.Accounts

  action_fallback QRClassWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index, teachers: Accounts.list_teachers())
  end
end
