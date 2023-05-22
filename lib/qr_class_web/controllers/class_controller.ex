defmodule QRClassWeb.ClassController do
  use QRClassWeb, :controller
  alias QRClass.Course

  action_fallback(QRClassWeb.FallbackController)

  def index(conn, _params) do
    render(conn, :index, classes: Course.list_classes())
  end

  def create(conn, params) do
    with {:ok, class} <- Course.create_class(params) do
      render(conn, :show, class: class)
    end
  end

  def create_class_session(conn, params) do
    with {:ok, class_session} <- Course.create_class_session(params) do
      render(conn, :show, class_session: class_session)
    end
  end
end
