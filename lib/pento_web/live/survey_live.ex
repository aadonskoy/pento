defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias PentoWeb.Endpoint
  alias PentoWeb.{DemographicLive, RatingLive, Router}

  @survey_results_topic "survey_results"

  @impl true
  def render(assigns) do
    ~H"""
      <section class="row">
        <h2>Survey</h2>
      </section>
      <section class="row">
        <%= if @demographic do %>
            <DemographicLive.Show.details demographic={@demographic} />
            <RatingLive.Index.products
              products={@products}
              current_user={@current_user}
              demographic={@demographic} />
        <% else %>
          <.live_component module={DemographicLive.Form} id="demographic-form" current_user={@current_user} />
        <% end %>
      </section>
    """
  end

  @impl true
  def mount(_params, _sessions, socket) do
    {
      :ok,
      socket
      |> assign_demographic()
      |> assign_products()
    }
  end

@impl true
  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_create(socket, demographic)}
  end

@impl true
  def handle_info({:created_rating, updated_product, product_index}, socket) do
    {:noreply, handle_rating_created(socket, updated_product, product_index)}
  end

  def handle_demographic_create(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end

  def handle_rating_created(
    %{assigns: %{products: products}} = socket,
    updated_product,
    product_index) do

    Endpoint.broadcast(@survey_results_topic, "rating_created", %{})

    socket
    |> put_flash(:info, "Rating submitted successfully")
    |> assign(products: List.replace_at(products, product_index, updated_product))
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(
      socket,
      :demographic,
      Pento.Survey.get_demographic_by_user(current_user)
    )
  end

  defp assign_products(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :products, list_products(current_user))
  end

  defp list_products(user) do
    Pento.Catalog.list_products_with_user_rating(user)
  end
end
