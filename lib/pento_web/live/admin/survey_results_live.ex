defmodule PentoWeb.Admin.SurveyResultsLive do
  alias Pento.Catalog
  alias Contex.Plot
  use PentoWeb, :live_component

  def render(assigns) do
    ~H"""
      <section>
        <h1>Survey Results</h1>
        <div class="survey-results-component">
          <.form
            for={:age_group_filter}
            phx-change="age_group_filter"
            phx-target={@myself}
            id={@id}>

            <label>Filter by age group:</label>
            <select name="age_group_filter" id="age_group_filter">
              <%= for age_group <- ["all", "18 and under", "18 to 25", "25 to 35", "35 and up"] do %>
                <option
                  value={age_group}
                  selected={@age_group_filter == age_group}>
                  <%= age_group %>
                </option>
              <% end %>
            </select>
          </.form>

          <div class="survey-results-chart">
            <%= @chart_svg %>
          </div>
        </div>
      </section>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign_age_group_filter()
      |> assign_products_with_average_ratings()
      |> assign_dataset()
      |> assign_chart()
      |> assign_chart_svg()
    }
  end

  @impl true
  def handle_event("age_group_filter", %{"age_group_filter" => age_group_filter}, socket) do
    {:noreply,
      socket
      |> assign_age_group_filter(age_group_filter)
      |> assign_products_with_average_ratings()
      |> assign_dataset()
      |> assign_chart()
      |> assign_chart_svg()
    }
  end

  defp assign_products_with_average_ratings(%{assigns: %{age_group_filter: age_group_filter}} = socket) do
    assign(
      socket,
      :products_with_average_ratings,
      get_products_with_average_ratings(%{age_group_filter: age_group_filter})
    )
  end

  defp get_products_with_average_ratings(filter) do
    case Catalog.products_with_average_ratings(filter) do
      [] -> Catalog.products_with_zero_ratings()
      products -> products
    end
  end

  def assign_dataset(
    %{assigns: %{
      products_with_average_ratings: products_with_average_ratings
    }} = socket
  ) do
    socket
    |> assign(
      :dataset,
      make_bar_chart_dataset(products_with_average_ratings)
    )
  end

  defp make_bar_chart_dataset(data) do
    Contex.Dataset.new(data)
  end

  def assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket
    |> assign(:chart, make_bar_chart(dataset))
  end

  defp make_bar_chart(dataset) do
    Contex.BarChart.new(dataset)
  end

  defp assign_age_group_filter(socket, age_group \\ "all") do
    socket
    |> assign(:age_group_filter, age_group)
  end

  def assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    socket
    |> assign(:chart_svg, render_bar_chart(chart))
  end

  defp render_bar_chart(chart) do
    Plot.new(500, 400, chart)
    |> Plot.titles(title(), subtitle())
    |> Plot.axis_labels(x_axis(), y_axis())
    |> Plot.to_svg()
  end

  defp title do
    "Product Ratings"
  end

  defp subtitle do
    "average star ratings per product"
  end

  defp x_axis do
    "products"
  end

  defp y_axis do
    "stars"
  end
end
