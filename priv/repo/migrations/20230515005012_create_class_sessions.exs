defmodule QRClass.Repo.Migrations.CreateClassSessions do
  use Ecto.Migration

  def change do
    create table(:class_sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :datetime, :utc_datetime
      add :online, :boolean, default: false, null: false
      add :class_id, references(:classes, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:class_sessions, [:class_id])
  end
end
