defmodule QRClassWeb.TeacherJSON do
  alias QRClass.Accounts.User

  def index(%{teachers: teachers}) do
    %{teachers: Enum.map(teachers, &data/1)}
  end

  defp data(%User{} = teacher) do
    %{
      id: teacher.id,
      email: teacher.email
    }
  end
end
