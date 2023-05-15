defmodule QRClass.Repo.Migrations.CreateStudentClasses do
  use Ecto.Migration

  def change do
    create table(:student_classes, primary_key: false) do
      add :class_id, references(:classes, on_delete: :nothing, type: :binary_id)
      add :student_id, references(:users, on_delete: :nothing, type: :binary_id)
    end

    create index(:student_classes, [:class_id])
    create index(:student_classes, [:student_id])
  end
end
