defmodule QRClassWeb.ClassJSON do
  alias QRClassWeb.StudentJSON
  alias QRClassWeb.TeacherJSON
  alias QRClass.Course.Class


  def index(%{classes: classes}) do
    %{data: Enum.map(classes, &data/1)}
  end

  def show(%{class: class}) do
    %{data: data(class)}
  end

  defp data(%Class{} = class) do
    %{
      id: class.id,
      name: class.name,
      cover_img: class.cover_img,
      teacher: TeacherJSON.data(class.teacher),
      students: Enum.map(class.students, &StudentJSON.data(&1))
    }
  end
end
