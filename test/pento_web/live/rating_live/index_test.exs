defmodule PentoWeb.RatingLive.IndexTest do
  use PentoWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Pento.{Accounts, Catalog, Survey}

  @create_product_attrs %{
    description: "test description",
    name: "Test Game",
    sku: 4223124,
    unit_price: 120.5
  }
  @create_demographic_attrs %{
    gender: "female",
    education: "other",
    year_of_birth: DateTime.utc_now.year - 15
  }
  @create_user_attrs %{
    email: "test1@test.com",
    username: "user1",
    password: "passwordpasseword"
  }

  defp product_fixture do
    {:ok, product} = Catalog.create_product(@create_product_attrs)
    product
  end

  defp user_fixture(attrs \\ @create_user_attrs) do
    {:ok, user} = Accounts.register_user(attrs)
    user
  end

  defp demographic_fixture(user, attrs) do
    attrs =
      attrs
      |> Map.merge(%{user_id: user.id})
    {:ok, demographic} = Survey.create_demographic(attrs)
    demographic
  end

  defp rating_fixture(user, product, stars) do
    {:ok, rating} = Survey.create_rating(%{
      stars: stars,
      user_id: user.id,
      product_id: product.id
    })
    rating
  end

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_rating(user, product, stars) do
    rating = rating_fixture(user, product, stars)
    %{rating: rating}
  end

  defp create_demographic(user, attrs \\ @create_demographic_attrs) do
    demographic = demographic_fixture(user, attrs)
    %{demographic: demographic}
  end

  describe "no rating" do
    setup [:create_user, :create_product]

    setup %{user: user} do
      demographic = create_demographic(user)
      products = Catalog.list_products_with_user_rating (user)
      [demographic: demographic, products: products]
    end

    test "create rating form exist", %{user: user, demographic: demographic, products: products} do
      html = render_component(
        &PentoWeb.RatingLive.Index.list/1,
        current_user: user,
        products: products,
        demographics: demographic
      )
      assert html =~ "Test Game"
      assert html =~ "<form"
    end
  end

  describe "with rating" do
    setup [:create_user, :create_product]

    setup %{user: user, product: product} do
      demographic = create_demographic(user)
      create_rating(user, product, 4)
      products = Catalog.list_products_with_user_rating (user)
      [demographic: demographic, products: products]
    end

    test "rating exist", %{user: user, demographic: demographic, products: products} do
      html = render_component(
        &PentoWeb.RatingLive.Index.list/1,
        current_user: user,
        products: products,
        demographics: demographic
      )
      assert html =~ "Test Game"
      assert html =~ "&#x2605; &#x2605; &#x2605; &#x2605; &#x2606;"
    end
  end
end
