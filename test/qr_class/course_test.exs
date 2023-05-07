defmodule QRClass.CourseTest do
  use QRClass.DataCase

  alias QRClass.Course

  describe "classes" do
    alias QRClass.Course.Class

    import QRClass.CourseFixtures

    @invalid_attrs %{cover_img: nil, name: nil}

    test "list_classes/0 returns all classes" do
      class = class_fixture()
      assert Course.list_classes() == [class]
    end

    test "get_class!/1 returns the class with given id" do
      class = class_fixture()
      assert Course.get_class!(class.id) == class
    end

    test "create_class/1 with valid data creates a class" do
      valid_attrs = %{cover_img: "some cover_img", name: "some name"}

      assert {:ok, %Class{} = class} = Course.create_class(valid_attrs)
      assert class.cover_img == "some cover_img"
      assert class.name == "some name"
    end

    test "create_class/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Course.create_class(@invalid_attrs)
    end

    test "update_class/2 with valid data updates the class" do
      class = class_fixture()
      update_attrs = %{cover_img: "some updated cover_img", name: "some updated name"}

      assert {:ok, %Class{} = class} = Course.update_class(class, update_attrs)
      assert class.cover_img == "some updated cover_img"
      assert class.name == "some updated name"
    end

    test "update_class/2 with invalid data returns error changeset" do
      class = class_fixture()
      assert {:error, %Ecto.Changeset{}} = Course.update_class(class, @invalid_attrs)
      assert class == Course.get_class!(class.id)
    end

    test "delete_class/1 deletes the class" do
      class = class_fixture()
      assert {:ok, %Class{}} = Course.delete_class(class)
      assert_raise Ecto.NoResultsError, fn -> Course.get_class!(class.id) end
    end

    test "change_class/1 returns a class changeset" do
      class = class_fixture()
      assert %Ecto.Changeset{} = Course.change_class(class)
    end
  end
end
