defmodule QRClassWeb.ClassController do
  use QRClassWeb, :controller
  alias QRClass.Course

  action_fallback QRClassWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index, classes: Course.list_classes())
  end

  def create(conn, params) do
    with {:ok, class} <- Course.create_class(params) do
      render(conn, :show, class: class)
    end
  end
end
