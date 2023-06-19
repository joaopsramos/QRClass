defmodule QRClass.Course.Class do
  use Ecto.Schema
  import Ecto.Changeset

  alias QRClass.Accounts
  alias Ecto.Changeset
  alias QRClass.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "classes" do
    field(:name, :string)
    field(:student_ids, {:array, :string}, virtual: true, default: [])

    belongs_to(:teacher, User)

    many_to_many(:students, User,
      join_through: "student_classes",
      join_keys: [class_id: :id, student_id: :id]
    )

    timestamps()
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:name, :student_ids, :teacher_id])
    |> validate_required([:name, :teacher_id])
    |> put_students()
    |> foreign_key_constraint(:teacher_id)
  end

  defp put_students(%Changeset{valid?: false} = changeset), do: changeset

  defp put_students(changeset) do
    student_ids = get_field(changeset, :student_ids)
    students = Accounts.get_users_by_ids(student_ids)
    invalid_ids = student_ids -- Enum.map(students, & &1.id)

    if invalid_ids == [] do
      put_assoc(changeset, :students, students)
    else
      add_error(changeset, :students, "students not found: [%{student_ids}]",
        student_ids: Enum.join(invalid_ids, ",")
      )
    end
  end
end
