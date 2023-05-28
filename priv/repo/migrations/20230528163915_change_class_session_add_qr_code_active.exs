defmodule QRClass.Repo.Migrations.ChangeClassSessionAddQrCodeActive do
  use Ecto.Migration

  def change do
    alter table(:class_sessions) do
      add :qr_code_active, :boolean
    end
  end
end
