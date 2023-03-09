defmodule PentoWeb.ProductLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pento.AccountsFixtures
  import Pento.CatalogFixtures

  @create_attrs %{
    description: "some description",
    name: "some name",
    sku: 2_345_642,
    unit_price: 120.5
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    sku: 6_534_243,
    unit_price: 456.7
  }
  @invalid_attrs %{description: nil, name: nil, sku: nil, unit_price: nil}

  setup(%{conn: conn}) do
    user = user_fixture()
    conn = log_in_user(conn, user)
    %{conn: conn, product: product_fixture(), user: user}
  end

  describe "Index" do
    test "lists all products", %{conn: conn, product: product} do
      {:ok, _index_live, html} = live(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Listing Products"
      assert html =~ product.description
    end

    test "saves new product", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("a", "New Product") |> render_click() =~
               "New Product"

      assert_patch(index_live, Routes.product_index_path(conn, :new))

      assert index_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      image =
        index_live
        |> file_input("#product-form", :image, [
          %{
            name: "test_image.png",
            content: File.read!("test/support/fixtures/test_image.png"),
            type: "image/png"
          }
        ])

      assert render_upload(image, "test_image.png") =~ " uploaded"

      {:ok, _, html} =
        index_live
        |> form("#product-form", product: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Product created successfully"
      assert html =~ "some description"
    end

    test "updates product in listing", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("#product-#{product.id} a", "Edit") |> render_click() =~
               "Edit Product"

      assert_patch(index_live, Routes.product_index_path(conn, :edit, product))

      assert index_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      image =
        index_live
        |> file_input("#product-form", :image, [
          %{
            name: "test_image.png",
            content: File.read!("test/support/fixtures/test_image.png"),
            type: "image/png"
          }
        ])

      assert render_upload(image, "test_image.png") =~ " uploaded"

      {:ok, _, html} =
        index_live
        |> form("#product-form", product: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_index_path(conn, :index))

      assert html =~ "Product updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes product in listing", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, Routes.product_index_path(conn, :index))

      assert index_live |> element("#product-#{product.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#product-#{product.id}")
    end
  end

  describe "Show" do
    test "displays product", %{conn: conn, product: product} do
      {:ok, _show_live, html} = live(conn, Routes.product_show_path(conn, :show, product))

      assert html =~ "Show Product"
      assert html =~ product.description
    end

    test "updates product within modal", %{conn: conn, product: product} do
      {:ok, show_live, _html} = live(conn, Routes.product_show_path(conn, :show, product))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Product"

      assert_patch(show_live, Routes.product_show_path(conn, :edit, product))

      assert show_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      image =
        show_live
        |> file_input("#product-form", :image, [
          %{
            name: "test_image.png",
            content: File.read!("test/support/fixtures/test_image.png"),
            type: "image/png"
          }
        ])

      assert render_upload(image, "test_image.png") =~ " uploaded"

      {:ok, _, html} =
        show_live
        |> form("#product-form", product: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_show_path(conn, :show, product))

      assert html =~ "Product updated successfully"
      assert html =~ "some updated description"
    end
  end
end
