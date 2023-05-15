
defmodule QRClassWeb.StudentJSON do
  alias QRClass.Accounts.User

  def index(%{students: students}) do
    %{students: Enum.map(students, &data/1)}
  end

  def data(%User{} = student) do
    %{
      id: student.id,
      email: student.email
    }
  end
end
