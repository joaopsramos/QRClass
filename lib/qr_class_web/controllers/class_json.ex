defmodule QRClassWeb.ClassJSON do
  alias QRClassWeb.StudentJSON
  alias QRClassWeb.TeacherJSON
  alias QRClass.Course.Class
  alias QRClass.Course.ClassSession

  def index(%{classes: classes}) do
    %{data: Enum.map(classes, &data/1)}
  end

  def show(%{class: class}) do
    %{data: data(class)}
  end

  def show(%{class_session: class_session}) do
    %{data: data(class_session)}
  end

  defp data(%ClassSession{} = class_session) do
    %{
      id: class_session.id,
      online: class_session.online,
      start_date: class_session.start_date,
      end_date: class_session.end_date,
      class_id: class_session.class_id
    }
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
