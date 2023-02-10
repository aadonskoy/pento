defmodule PentoWeb.SearchLive do
  use PentoWeb, :live_view

  alias Pento.Catalog.Product

  def render(assigns) do
    ~H"""
    <h2>Search Product</h2>
    <.form
      let={f}
      for={@changeset}
      id="search-sku-form"
      phx-change="validate"
      phx-submit="search">

      <%= label f, :sku %>
      <%= text_input f, :sku %>
      <%= error_tag f, :sku %>

      <%= submit "Search", phx_disable_with: "Searching..." %>
    </.form>

    <%= if @product.id do %>
      <ul>

        <li>
          <strong>Name:</strong>
          <%= @product.name %>
        </li>

        <li>
          <strong>Description:</strong>
          <%= @product.description %>
        </li>

        <li>
          <strong>Unit price:</strong>
          <%= @product.unit_price %>
        </li>

        <li>
          <strong>Sku:</strong>
          <%= @product.sku %>
        </li>

      </ul>
    <% end %>
    """
  end

  def mount(_params, _sessions, socket) do
    changeset = Product.search_sku_changeset(%Product{}, %{})
    {
      :ok,
      socket
      |> assign(%{changeset: changeset})
      |> assign(%{product: %Product{}})
    }
  end

  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      %Product{}
      |> Product.search_sku_changeset(product_params)
      |> Map.put(:action, :insert)
    {
      :noreply,
      assign(socket, %{changeset: changeset})
    }
  end

  def handle_event("search", %{"product" => %{ "sku" => sku } = product_params}, socket) do
    changeset =
      %Product{}
      |> Product.search_sku_changeset(product_params)
    case changeset.valid? do
      true -> {
        :noreply,
        socket
        |> assign(%{changeset: changeset})
        |> assign(%{product: Pento.Catalog.get_by_sku(sku)})
      }
      false -> {
        :noreply,
        socket
        |> assign(%{changeset: changeset})
        |> assign(%{product: %Product{}})
      }
    end
  end
end
