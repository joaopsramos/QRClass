defmodule QRClassWeb.StoreIP do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    ip =
      conn.remote_ip
      |> :inet.ntoa()
      |> to_string()

    put_session(conn, :ip, ip)
  end
end
