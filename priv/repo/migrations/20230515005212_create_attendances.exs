defmodule QRClass.Repo.Migrations.CreateAttendances do
  use Ecto.Migration

  def change do
    create table(:attendances, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :attended, :boolean, default: false, null: false
      add :class_id, references(:classes, on_delete: :nothing, type: :binary_id)
      add :class_session_id, references(:class_sessions, on_delete: :nothing, type: :binary_id)
      add :student_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:attendances, [:class_id])
    create index(:attendances, [:class_session_id])
    create index(:attendances, [:student_id])
  end
end
