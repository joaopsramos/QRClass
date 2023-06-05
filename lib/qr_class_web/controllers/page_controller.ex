defmodule QRClassWeb.PageController do
  use QRClassWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/users/log_in")
  end

  def account_created(conn, _params) do
    render(conn, :account_created)
  end
end
