defmodule QRClass.Repo.Migrations.ChangeClassRemoveCoverImg do
  use Ecto.Migration

  def change do
    alter table(:classes) do
      remove :cover_img
    end
  end
end
