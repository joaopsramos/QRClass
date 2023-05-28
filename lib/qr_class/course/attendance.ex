defmodule QRClass.Course.Attendance do
  use Ecto.Schema
  import Ecto.Changeset

  alias QRClass.Accounts.User
  alias QRClass.Course.ClassSession

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "attendances" do
    field :attended, :boolean, default: false

    belongs_to :class, Class
    belongs_to :class_session, ClassSession
    belongs_to :student, User

    timestamps()
  end

  @doc false
  def changeset(attendance, attrs) do
    attendance
    |> cast(attrs, [:attended, :class_id, :class_session_id, :student_id])
    |> validate_required([:attended, :class_session_id, :student_id])
  end
end
