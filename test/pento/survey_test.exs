defmodule Pento.SurveyTest do
  use Pento.DataCase

  alias Pento.CatalogFixtures
  alias Pento.AccountsFixtures
  alias Pento.Survey

  describe "demographics" do
    alias Pento.Survey.Demographic
    alias Pento.AccountsFixtures

    import Pento.SurveyFixtures

    @invalid_attrs %{gender: nil, year_of_birth: nil, education: nil, user_id: nil}

    defp create_user(_) do
      user = AccountsFixtures.user_fixture()
      %{user: user}
    end

    setup [:create_user]

    test "list_demographics/0 returns all demographics", %{user: user} do
      demographic = demographic_fixture(user)
      assert Survey.list_demographics() == [demographic]
    end

    test "get_demographic!/1 returns the demographic with given id", %{user: user} do
      demographic = demographic_fixture(user)
      assert Survey.get_demographic!(demographic.id) == demographic
    end

    test "create_demographic/1 with valid data creates a demographic", %{user: user} do
      valid_attrs = %{year_of_birth: 42, user_id: user.id, gender: "other", education: "other"}

      assert {:ok, %Demographic{} = demographic} = Survey.create_demographic(valid_attrs)
      assert demographic.user_id == user.id
      assert demographic.gender == "other"
      assert demographic.education == "other"
      assert demographic.year_of_birth == 42
    end

    test "create_demographic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Survey.create_demographic(@invalid_attrs)
    end

    test "update_demographic/2 with valid data updates the demographic", %{user: user} do
      demographic = demographic_fixture(user)
      update_attrs = %{gender: "other", year_of_birth: 43}

      assert {:ok, %Demographic{} = demographic} =
               Survey.update_demographic(demographic, update_attrs)

      assert demographic.gender == "other"
      assert demographic.year_of_birth == 43
    end

    test "update_demographic/2 with invalid data returns error changeset", %{user: user} do
      demographic = demographic_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Survey.update_demographic(demographic, @invalid_attrs)
      assert demographic == Survey.get_demographic!(demographic.id)
    end

    test "delete_demographic/1 deletes the demographic", %{user: user} do
      demographic = demographic_fixture(user)
      assert {:ok, %Demographic{}} = Survey.delete_demographic(demographic)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_demographic!(demographic.id) end
    end

    test "change_demographic/1 returns a demographic changeset", %{user: user} do
      demographic = demographic_fixture(user)
      assert %Ecto.Changeset{} = Survey.change_demographic(demographic)
    end
  end

  describe "ratings" do
    alias Pento.Survey.Rating
    alias Pento.CatalogFixtures
    alias Pento.AccountsFixtures

    import Pento.SurveyFixtures

    @invalid_attrs %{stars: nil}

    defp create_product(_) do
      product = CatalogFixtures.product_fixture()
      %{product: product}
    end

    setup [:create_user, :create_product]

    test "list_ratings/0 returns all ratings", %{user: user, product: product} do
      rating = rating_fixture(user, product)
      assert Survey.list_ratings() == [rating]
    end

    test "get_rating!/1 returns the rating with given id", %{user: user, product: product} do
      rating = rating_fixture(user, product)
      assert Survey.get_rating!(rating.id) == rating
    end

    test "create_rating/1 with valid data creates a rating", %{user: user, product: product} do
      valid_attrs = %{stars: 2, user_id: user.id, product_id: product.id}

      assert {:ok, %Rating{} = rating} = Survey.create_rating(valid_attrs)
      assert rating.stars == 2
    end

    test "create_rating/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Survey.create_rating(@invalid_attrs)
    end

    test "update_rating/2 with valid data updates the rating", %{user: user, product: product} do
      rating = rating_fixture(user, product)
      update_attrs = %{stars: 4}

      assert {:ok, %Rating{} = rating} = Survey.update_rating(rating, update_attrs)
      assert rating.stars == 4
    end

    test "update_rating/2 with invalid data returns error changeset", %{
      user: user,
      product: product
    } do
      rating = rating_fixture(user, product)
      assert {:error, %Ecto.Changeset{}} = Survey.update_rating(rating, @invalid_attrs)
      assert rating == Survey.get_rating!(rating.id)
    end

    test "delete_rating/1 deletes the rating", %{user: user, product: product} do
      rating = rating_fixture(user, product)
      assert {:ok, %Rating{}} = Survey.delete_rating(rating)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_rating!(rating.id) end
    end

    test "change_rating/1 returns a rating changeset", %{user: user, product: product} do
      rating = rating_fixture(user, product)
      assert %Ecto.Changeset{} = Survey.change_rating(rating)
    end
  end
end
