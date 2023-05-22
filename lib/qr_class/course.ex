defmodule QRClass.Course do
  @moduledoc """
  The Course context.
  """

  import Ecto.Query, warn: false

  alias QRClass.Course.Class
  alias QRClass.Course.ClassSession
  alias QRClass.Repo

  def can_generate_qr_code?(%ClassSession{} = class_session) do
    # Timex.between?(DateTime.utc_now(), class_session.start_date, class_session.end_date)
    true
  end

  def create_class_session(attrs \\ %{}) do
    %ClassSession{}
    |> ClassSession.changeset(attrs)
    |> Repo.insert()
  end

  def get_teacher_classes(teacher_id) do
    Repo.all(from c in Class, where: c.teacher_id == ^teacher_id)
  end

  def list_class_sessions_by_class_id(class_id) do
    Repo.all(from cs in ClassSession, where: cs.class_id == ^class_id)
  end

  @doc """
  Returns the list of classes.

  ## Examples

      iex> list_classes()
      [%Class{}, ...]

  """
  def list_classes do
    Repo.all(from c in Class, preload: [:teacher, :students])
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
end
