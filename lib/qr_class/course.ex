defmodule QRClass.Course do
  @moduledoc """
  The Course context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias QRClass.Accounts.User
  alias QRClass.Course.Attendance
  alias QRClass.Course
  alias QRClass.Course.Class
  alias QRClass.Course.ClassSession
  alias QRClass.Repo

  def create_attendance(%User{} = student, %ClassSession{} = class_session) do
    %Attendance{}
    |> Attendance.changeset(%{
      student_id: student.id,
      class_session_id: class_session.id,
      class_id: class_session.class_id
    })
    |> Repo.insert()
  end

  def register_presence(%Attendance{} = attendance) do
    attendance
    |> Attendance.changeset(%{attended: true})
    |> Repo.update()
  end

  def remove_presence(%Attendance{} = attendance) do
    attendance
    |> Attendance.changeset(%{attended: false})
    |> Repo.update()
  end

  def get_attendance(student_id, class_session_id) do
    Repo.get_by(Attendance, student_id: student_id, class_session_id: class_session_id)
  end

  def active_qr_code(%ClassSession{} = class_session) do
    if can_active_qr_code?(class_session) do
      class_session
      |> ClassSession.changeset(%{qr_code_active: true})
      |> Repo.update()
    else
      {:error, :could_not_activate}
    end
  end

  def inactive_qr_code(%ClassSession{} = class_session) do
    class_session
    |> ClassSession.changeset(%{qr_code_active: false})
    |> Repo.update!()
  end

  def can_active_qr_code?(%ClassSession{} = _class_session) do
    # now = Timex.shift(Timex.now(), hours: -3)
    #
    # Timex.between?(now, class_session.start_date, class_session.end_date)
    true
  end

  def create_class_session(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:class_session, ClassSession.changeset(%ClassSession{}, attrs))
    |> Multi.run(:attendances, fn _repo, %{class_session: class_session} ->
      students = get_class_students(class_session.class_id)

      attendances =
        for student <- students do
          create_attendance(student, class_session)
        end

      if Enum.all?(attendances, &(elem(&1, 0) == :ok)) do
        {:ok, attendances}
      else
        {:error, "One or more attendances could no be created"}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{class_session: class_session}} -> {:ok, class_session}
      {:error, :class_session, changeset, _} -> {:error, changeset}
      error -> error
    end
  end

  def get_class_students(class_id) do
    query =
      from(u in User,
        join: c in assoc(u, :classes_as_student),
        on: c.id == ^class_id
      )

    Repo.all(query)
  end

  def get_class_session(id) do
    Repo.get(ClassSession, id)
  end

  def get_class_session(id, preload) do
    from(cs in ClassSession, preload: ^preload)
    |> Repo.get(id)
  end

  def get_teacher_classes(teacher_id) do
    Repo.all(from(c in Class, where: c.teacher_id == ^teacher_id))
  end

  def list_class_sessions_by_class_id(class_id) do
    Repo.all(from(cs in ClassSession, where: cs.class_id == ^class_id))
  end

  def list_classes do
    Repo.all(from(c in Class, preload: [:teacher, :students]))
  end

  def get_class!(id), do: Repo.get!(Class, id)

  def create_class(attrs \\ %{}) do
    result =
      %Class{}
      |> Class.changeset(attrs)
      |> Repo.insert()

    with {:ok, class} <- result do
      {:ok, Repo.preload(class, [:teacher, :students])}
    end
  end

  def update_class(%Class{} = class, attrs) do
    class
    |> Class.changeset(attrs)
    |> Repo.update()
  end

  def delete_class(%Class{} = class) do
    Repo.delete(class)
  end

  def change_class(%Class{} = class, attrs \\ %{}) do
    Class.changeset(class, attrs)
  end

  def change_qr_code(%Course.QRCode{} = qr_code, attrs \\ %{}) do
    Course.QRCode.changeset(qr_code, attrs)
  end
end
