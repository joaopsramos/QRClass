defmodule QRClassWeb.ClassLiveTest do
  use QRClassWeb.ConnCase

  import Phoenix.LiveViewTest
  import QRClass.CourseFixtures

  @create_attrs %{cover_img: "some cover_img", name: "some name"}
  @update_attrs %{cover_img: "some updated cover_img", name: "some updated name"}
  @invalid_attrs %{cover_img: nil, name: nil}

  defp create_class(_) do
    class = class_fixture()
    %{class: class}
  end

  describe "Index" do
    setup [:create_class]

    test "lists all classes", %{conn: conn, class: class} do
      {:ok, _index_live, html} = live(conn, ~p"/classes")

      assert html =~ "Listing Classes"
      assert html =~ class.cover_img
    end

    test "saves new class", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/classes")

      assert index_live |> element("a", "New Class") |> render_click() =~
               "New Class"

      assert_patch(index_live, ~p"/classes/new")

      assert index_live
             |> form("#class-form", class: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#class-form", class: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/classes")

      html = render(index_live)
      assert html =~ "Class created successfully"
      assert html =~ "some cover_img"
    end

    test "updates class in listing", %{conn: conn, class: class} do
      {:ok, index_live, _html} = live(conn, ~p"/classes")

      assert index_live |> element("#classes-#{class.id} a", "Edit") |> render_click() =~
               "Edit Class"

      assert_patch(index_live, ~p"/classes/#{class}/edit")

      assert index_live
             |> form("#class-form", class: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#class-form", class: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/classes")

      html = render(index_live)
      assert html =~ "Class updated successfully"
      assert html =~ "some updated cover_img"
    end

    test "deletes class in listing", %{conn: conn, class: class} do
      {:ok, index_live, _html} = live(conn, ~p"/classes")

      assert index_live |> element("#classes-#{class.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#classes-#{class.id}")
    end
  end

  describe "Show" do
    setup [:create_class]

    test "displays class", %{conn: conn, class: class} do
      {:ok, _show_live, html} = live(conn, ~p"/classes/#{class}")

      assert html =~ "Show Class"
      assert html =~ class.cover_img
    end

    test "updates class within modal", %{conn: conn, class: class} do
      {:ok, show_live, _html} = live(conn, ~p"/classes/#{class}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Class"

      assert_patch(show_live, ~p"/classes/#{class}/show/edit")

      assert show_live
             |> form("#class-form", class: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#class-form", class: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/classes/#{class}")

      html = render(show_live)
      assert html =~ "Class updated successfully"
      assert html =~ "some updated cover_img"
    end
  end
end
