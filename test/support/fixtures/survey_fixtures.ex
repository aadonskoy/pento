defmodule Pento.SurveyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Survey` context.
  """

  @doc """
  Generate a demographic.
  """
  def demographic_fixture(user, attrs \\ %{}) do
    {:ok, demographic} =
      attrs
      |> Enum.into(%{
        gender: "other",
        education: "other",
        user_id: user.id,
        year_of_birth: 42
      })
      |> Pento.Survey.create_demographic()

    demographic
  end

  @doc """
  Generate a rating.
  """
  def rating_fixture(user, product, attrs \\ %{}) do
    {:ok, rating} =
      attrs
      |> Enum.into(%{
        stars: 3,
        user_id: user.id,
        product_id: product.id
      })
      |> Pento.Survey.create_rating()

    rating
  end
end
