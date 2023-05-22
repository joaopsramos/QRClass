defmodule QRClass.Repo.Migrations.ChangeClassSessionAddStartDateEndDate do
  use Ecto.Migration

  def change do
    alter table(:class_sessions) do
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      remove :datetime
    end
  end
end
