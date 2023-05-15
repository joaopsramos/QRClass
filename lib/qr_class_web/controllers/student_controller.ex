
defmodule QRClassWeb.StudentController do
  use QRClassWeb, :controller

  alias QRClass.Accounts

  action_fallback QRClassWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index, students: Accounts.list_students())
  end
end
