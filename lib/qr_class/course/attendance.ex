defmodule QRClass.Course.Attendance do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "attendances" do
    field :attended, :boolean, default: false
    field :class_id, :binary_id
    field :class_session_id, :binary_id
    field :student_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(attendance, attrs) do
    attendance
    |> cast(attrs, [:attended])
    |> validate_required([:attended])
  end
end
