defmodule Pento.Catalog.Product.Query do
  @moduledoc false

  import Ecto.Query

  alias Pento.Survey.Demographic
  alias Pento.Catalog.Product
  alias Pento.Survey.Rating

  def base, do: Product

  def with_user_ratings(user) do
    base()
    |> preload_user_ratings(user)
  end

  def preload_user_ratings(query, user) do
    ratings_query = Rating.Query.preload_user(user)

    query
    |> preload(ratings: ^ratings_query)
  end

  def with_average_ratings(query \\ base()) do
    query
    |> join_ratings
    |> average_ratings
  end

  defp join_ratings(query) do
    query
    |> join(:inner, [p], r in Rating, on: r.product_id == p.id)
  end

  defp average_ratings(query) do
    query
    |> group_by([p], p.id)
    |> select([p, r], {p.name, fragment("?::float", avg(r.stars()))})
  end

  def join_users(query \\ base()) do
    query
    |> join(:left, [p, r], u in Pento.Accounts.User, on: r.user_id == u.id)
  end

  def join_demographics(query \\ base()) do
    query
    |> join(:left, [p, r, u, d], d in Demographic, on: d.user_id == u.id)
  end

  # Age group filter

  def filter_by_age_group(query \\ base(), filter) do
    query
    |> apply_age_group_filter(filter)
  end

  defp apply_age_group_filter(query, "18 and under") do
    birth_year = DateTime.utc_now().year - 18

    query
    |> where([p, r, u, d], d.year_of_birth >= ^birth_year)
  end

  defp apply_age_group_filter(query, "18 to 25") do
    birth_year_max = DateTime.utc_now().year - 18
    birth_year_min = DateTime.utc_now().year - 25

    query
    |> where(
      [p, r, u, d],
      d.year_of_birth >= ^birth_year_min and
        d.year_of_birth <= ^birth_year_max
    )
  end

  defp apply_age_group_filter(query, "25 to 35") do
    birth_year_max = DateTime.utc_now().year - 25
    birth_year_min = DateTime.utc_now().year - 35

    query
    |> where(
      [p, r, u, d],
      d.year_of_birth >= ^birth_year_min and
        d.year_of_birth <= ^birth_year_max
    )
  end

  defp apply_age_group_filter(query, "35 and up") do
    birth_year = DateTime.utc_now().year - 35

    query
    |> where([p, r, u, d], d.year_of_birth <= ^birth_year)
  end

  defp apply_age_group_filter(query, _filter) do
    query
  end

  # Gender group filter

  def filter_by_gender_group(query \\ base(), filter) do
    query
    |> apply_gender_group_filter(filter)
  end

  def apply_gender_group_filter(query, filter)
      when filter in ["female", "male", "other", "prefer not to say"] do
    query
    |> where([p, r, u, d], d.gender == ^filter)
  end

  def apply_gender_group_filter(query, _filter) do
    query
  end

  def with_zero_ratings(query \\ base()) do
    query
    |> select([p], {p.name, 0})
  end
end
