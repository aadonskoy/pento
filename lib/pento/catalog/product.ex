defmodule Pento.Catalog.Product do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float
    field :image_upload, :string

    timestamps()

    has_many :ratings, Pento.Survey.Rating
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_num_of_digits(:sku, 7)
    |> validate_number(:unit_price, greater_than: 0.0)
  end

  def search_sku_changeset(product, attrs) do
    product
    |> cast(attrs, [:sku])
    |> validate_required([:sku])
    |> validate_num_of_digits(:sku, 7)
  end

  def price_decrease_changeset(product, decrease_amount) do
    new_price = product.unit_price - decrease_amount
    changeset(product, %{unit_price: new_price})
  end

  def validate_num_of_digits(changeset, field, num) do
    validate_change(changeset, field, fn _, value ->
      digits_num = length(Integer.digits(value))

      if digits_num == num do
        []
      else
        [sku: "SKU must be #{num} digits"]
      end
    end)
  end
end
