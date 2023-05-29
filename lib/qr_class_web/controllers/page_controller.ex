defmodule QRClassWeb.PageController do
  use QRClassWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/users/log_in")
  end

  def student(conn, _params) do
    render(conn, :home)
  end
end
