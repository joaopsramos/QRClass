defmodule QRClass.Course.ClassSession do
  use Ecto.Schema
  import Ecto.Changeset

  alias QRClass.Course.Class
  alias QRClass.Course.Attendance

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "class_sessions" do
    field(:start_date, :utc_datetime)
    field(:end_date, :utc_datetime)
    field(:online, :boolean, default: false)
    field(:qr_code_active, :boolean, default: false)
    belongs_to(:class, Class)
    has_many(:attendances, Attendance)

    timestamps()
  end

  @doc false
  def changeset(class_session, attrs) do
    class_session
    |> cast(attrs, [:start_date, :end_date, :online, :class_id, :qr_code_active])
    |> validate_required([:start_date, :end_date, :online, :class_id])
    |> foreign_key_constraint(:class_id)
  end
end
