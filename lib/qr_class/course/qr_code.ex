defmodule QRClass.Course.QRCode do
  use Ecto.Schema
  import Ecto.Changeset

  alias QRClass.Course.ClassSession

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "qr_codes" do
    field(:expires_at, :utc_datetime)
    field(:qr_code, :string)
    belongs_to(:class_session, ClassSession)

    timestamps()
  end

  @doc false
  def changeset(qr_code, attrs) do
    qr_code
    |> cast(attrs, [:expires_at, :qr_code, :class_session_id])
    |> validate_required([:expires_at, :qr_code, :class_session_id])
  end
end
