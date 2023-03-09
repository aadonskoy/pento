defmodule Pento.Survey.Demographic do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "demographics" do
    field :education, :string
    field :gender, :string
    field :year_of_birth, :integer
    belongs_to :user, Pento.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(demographic, attrs) do
    demographic
    |> cast(attrs, [:gender, :year_of_birth, :education, :user_id])
    |> validate_required([:gender, :year_of_birth, :education, :user_id])
    |> validate_inclusion(:gender, ["male", "female", "other", "prefer not to say"])
    |> validate_inclusion(:education, [
      "high school",
      "bachelor's degree",
      "graduate degree",
      "other"
    ])
    |> unique_constraint(:user_id)
  end
end
