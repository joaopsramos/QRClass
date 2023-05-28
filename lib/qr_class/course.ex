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

  def can_active_qr_code?(%ClassSession{} = class_session) do
    # Timex.between?(DateTime.utc_now(), class_session.start_date, class_session.end_date)
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
        |> IO.inspect()

      if Enum.all?(attendances, &(elem(&1, 0) == :ok)) do
        {:ok, attendances}
      else
        {:error, "One or more attendances could no be created"}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{class_session: class_session}} -> {:ok, class_session}
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

  def get_teacher_classes(teacher_id) do
    Repo.all(from(c in Class, where: c.teacher_id == ^teacher_id))
  end

  def list_class_sessions_by_class_id(class_id) do
    Repo.all(from(cs in ClassSession, where: cs.class_id == ^class_id))
  end

  @doc """
  Returns the list of classes.

  ## Examples

      iex> list_classes()
      [%Class{}, ...]

  """
  def list_classes do
    Repo.all(from(c in Class, preload: [:teacher, :students]))
  end

  @doc """
  Gets a single class.

  Raises `Ecto.NoResultsError` if the Class does not exist.

  ## Examples

      iex> get_class!(123)
      %Class{}

      iex> get_class!(456)
      ** (Ecto.NoResultsError)

  """
  def get_class!(id), do: Repo.get!(Class, id)

  @doc """
  Creates a class.

  ## Examples

      iex> create_class(%{field: value})
      {:ok, %Class{}}

      iex> create_class(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_class(attrs \\ %{}) do
    result =
      %Class{}
      |> Class.changeset(attrs)
      |> Repo.insert()

    with {:ok, class} <- result do
      {:ok, Repo.preload(class, [:teacher, :students])}
    end
  end

  @doc """
  Updates a class.

  ## Examples

      iex> update_class(class, %{field: new_value})
      {:ok, %Class{}}

      iex> update_class(class, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_class(%Class{} = class, attrs) do
    class
    |> Class.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a class.

  ## Examples

      iex> delete_class(class)
      {:ok, %Class{}}

      iex> delete_class(class)
      {:error, %Ecto.Changeset{}}

  """
  def delete_class(%Class{} = class) do
    Repo.delete(class)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking class changes.

  ## Examples

      iex> change_class(class)
      %Ecto.Changeset{data: %Class{}}

  """
  def change_class(%Class{} = class, attrs \\ %{}) do
    Class.changeset(class, attrs)
  end

  def change_qr_code(%Course.QRCode{} = qr_code, attrs \\ %{}) do
    Course.QRCode.changeset(qr_code, attrs)
  end
end
