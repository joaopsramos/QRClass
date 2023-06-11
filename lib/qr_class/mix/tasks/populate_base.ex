defmodule Mix.Tasks.PopulateBase do
  use Mix.Task

  alias QRClass.Repo
  alias QRClass.Course
  alias QRClass.Accounts
  alias QRClass.Accounts.User

  def run(_) do
    Application.ensure_all_started(:qr_class)

    IO.puts("Starting...")
    Repo.transaction(&populate/0)
    IO.puts("Finished!")
  end

  defp populate do
    teachers =
      Enum.map(1..3, fn _ -> %{email: Faker.Internet.free_email(), type: User.teacher()} end)

    students =
      Enum.map(1..10, fn _ -> %{email: Faker.Internet.free_email(), type: User.student()} end)

    classes = ["Processamento de imagens", "Cálculo 1", "Teoria dos Grafos"]

    IO.puts("Creating users...")

    users =
      for user <- teachers ++ students do
        IO.puts("Creating user with email: #{user.email} and type: #{user.type}")

        password = "12345678"

        {:ok, user} =
          user
          |> Map.put(:password, password)
          |> Accounts.register_user()

        user
      end

    {teachers, students} = Enum.split_with(users, &(&1.type == User.teacher()))

    IO.puts("Creating classes...")

    classes =
      for teacher <- teachers, class <- classes do
        IO.puts("Creating class #{class} with teacher #{teacher.email}")

        student_ids = students |> Enum.take_random(5) |> Enum.map(& &1.id)

        {:ok, class} =
          Course.create_class(%{name: class, teacher_id: teacher.id, student_ids: student_ids})

        class
      end

    start_dates = [
      ~U[2023-06-12 19:00:00.000Z],
      ~U[2023-06-14 19:00:00.000Z],
      ~U[2023-06-15 19:00:00.000Z]
    ]

    IO.puts("Creating class sessions...")

    for {class, start_date} <- Enum.zip(classes, start_dates) do
      for n <- 1..7 do
        params = %{
          class_id: class.id,
          online: Enum.random([true, false]),
          start_date: Timex.shift(start_date, weeks: n),
          end_date: start_date |> Timex.shift(weeks: n) |> Timex.shift(hours: 3)
        }

        IO.puts(
          "Creating class session for #{class.name} with starting date #{params.start_date} and end date #{params.end_date}"
        )

        Course.create_class_session(params)
      end
    end
  end
end
