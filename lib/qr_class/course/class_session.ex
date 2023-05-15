defmodule QRClass.Course.ClassSession do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "class_sessions" do
    field :datetime, :utc_datetime
    field :online, :boolean, default: false
    field :class_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(class_session, attrs) do
    class_session
    |> cast(attrs, [:datetime, :online])
    |> validate_required([:datetime, :online])
  end
end
