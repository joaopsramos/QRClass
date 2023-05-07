defmodule QRClass.CourseFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `QRClass.Course` context.
  """

  @doc """
  Generate a class.
  """
  def class_fixture(attrs \\ %{}) do
    {:ok, class} =
      attrs
      |> Enum.into(%{
        cover_img: "some cover_img",
        name: "some name"
      })
      |> QRClass.Course.create_class()

    class
  end
end
