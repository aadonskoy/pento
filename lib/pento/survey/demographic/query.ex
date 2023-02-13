defmodule Pento.Survey.Demographic.Query do
  alias Pento.Survey.Demographic
  import Ecto.Query

  def base do
    Demographic
  end

  def for_user(query \\ base(), user) do
    query
    |> where([d], d.user_id == ^user.id)
  end
end
