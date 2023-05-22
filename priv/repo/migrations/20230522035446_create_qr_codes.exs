defmodule QRClass.Repo.Migrations.CreateQrCodes do
  use Ecto.Migration

  def change do
    create table(:qr_codes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :expires_at, :utc_datetime
      add :qr_code, :text
      add :class_session_id, references(:class_sessions, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:qr_codes, [:class_session_id])
  end
end
