defmodule PentoWeb.RatingLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Rating

  def render(assigns) do
    ~H"""
    <div class="survey-component-container">
      <section class="row">
        <h4><%= @product.name %></h4>
      </section>
      <section class="row">
        <.form
          let={f}
          for={@changeset}
          phx-change="validate"
          phx-submit="save"
          phx-target={@myself}
          id={@id}>

          <%= label f, :stars %>
          <%= select f, :stars, Enum.reverse(1..5) %>
          <%= error_tag f, :stars %>

          <%= hidden_input f, :user_id %>
          <%= hidden_input f, :product_id %>

          <%= submit "Save", phx_disable_with: "Saving..." %>
        </.form>
      </section>
    </div>
    """
  end

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_rating()
      |> assign_changeset()
    }
  end

  def handle_event("validate", %{"rating" => rating_params}, socket) do
    {:noreply, validate_rating(socket, rating_params)}
  end

  def handle_event("save", %{"rating" => rating_params}, socket) do
    {:noreply, save_rating(socket, rating_params)}
  end

  def assign_rating(%{assigns: %{current_user: user, product: product}} = socket) do
    assign(socket, :rating, %Rating{user_id: user.id, product_id: product.id})
  end

  def assign_changeset(%{assigns: %{rating: rating}} = socket) do
    assign(socket, :changeset, Survey.change_rating(rating))
  end

  defp validate_rating(socket, rating_params) do
    changeset =
      socket.assigns.rating
      |> Survey.change_rating(rating_params)
      |> Map.put(:action, :validate)

    assign(socket, :changeset, changeset)
  end

  defp save_rating(
         %{assigns: %{product_index: product_index, product: product}} = socket,
         rating_params
       ) do
    case Survey.create_rating(rating_params) do
      {:ok, rating} ->
        product = %{product | ratings: [rating]}
        send(self(), {:created_rating, product, product_index})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end
end
