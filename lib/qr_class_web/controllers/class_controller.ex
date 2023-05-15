defmodule QRClassWeb.ClassController do
  use QRClassWeb, :controller

  def create(conn, params) do
    params |> IO.inspect()
    json(conn, %{data: params})
  end
end
