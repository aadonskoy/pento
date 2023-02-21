defmodule Pento.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Catalog` context.
  """

  @doc """
  Generate a unique product sku.
  """
  def unique_product_sku, do: Enum.random(1000000..9999999)

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        sku: unique_product_sku(),
        image_upload: image_fixture(),
        unit_price: 120.5
      })
      |> Pento.Catalog.create_product()

    product
  end

  def upload_image_fixture() do
    image = %Plug.Upload{path: "test/fixtures/test_image.png", filename: "test_image.png"}
    image
  end

  def image_fixture(), do: "test/fixtures/test_image.png"
end
