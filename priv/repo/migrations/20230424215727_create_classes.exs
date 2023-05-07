defmodule QRClass.Repo.Migrations.CreateClasses do
  use Ecto.Migration

  def change do
    create table(:classes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :cover_img, :string
      add :teacher_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:classes, [:teacher_id])
  end
end
