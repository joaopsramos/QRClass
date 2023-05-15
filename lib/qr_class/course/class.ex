defmodule QRClass.Course.Class do
  use Ecto.Schema
  import Ecto.Changeset

  alias QRClass.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "classes" do
    field :cover_img, :string
    field :name, :string
    belongs_to :teacher, User

    timestamps()
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:name, :cover_img])
    |> validate_required([:name, :cover_img])
  end
end
