defmodule QRClass.Repo do
  use Ecto.Repo,
    otp_app: :qr_class,
    adapter: Ecto.Adapters.Postgres
end
