defmodule PentoWeb.Presence do
  @moduledoc false

  use Phoenix.Presence,
    otp_app: :pento,
    pubsub_server: Pento.PubSub

  alias PentoWeb.Presence
  @user_activity_topic "user_activity"
  @survey_activity_topic "survey_activity"

  def track_user(pid, product, user_email) do
    Presence.track(pid, @user_activity_topic, product.name, %{users: [%{email: user_email}]})
  end

  def track_survey_users(pid, user_id) do
    Presence.track(pid, @survey_activity_topic, user_id, %{})
  end

  def list_survey_users() do
    Presence.list(@survey_activity_topic)
  end

  def survey_users_amount() do
    list_survey_users()
    |> Enum.frequencies()
    |> Enum.count()
  end

  def list_products_and_users() do
    Presence.list(@user_activity_topic)
    |> Enum.map(&extract_product_with_users/1)
  end

  defp extract_product_with_users({product_name, %{metas: metas}}) do
    {product_name, users_from_metas_list(metas)}
  end

  defp users_from_metas_list(metas_list) do
    Enum.map(metas_list, &users_from_meta_map/1)
    |> List.flatten()
    |> Enum.uniq()
  end

  def users_from_meta_map(meta_map) do
    get_in(meta_map, [:users])
  end
end
