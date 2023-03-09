defmodule PentoWeb.DemographicLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Demographic

  def render(assigns) do
    ~H"""
    <div>
      <.form
        let={f}
        for={@changeset}
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
        id={@id}>

        <%= label f, :gender %>
        <%= select f, :gender, ["female", "male", "other", "prefer not to say"] %>
        <%= error_tag f, :gender %>

        <%= label f, :year_of_birth %>
        <%= select f, :year_of_birth, Enum.reverse(1940..2020) %>
        <%= error_tag f, :year_of_birth %>

        <%= label f, :education %>
        <%= select f, :education, ["high school", "bachelor's degree", "graduate degree", "other"] %>
        <%= error_tag f, :education %>

        <%= hidden_input f, :user_id %>

        <%= submit "Save", phx_disable_with: "Saving..." %>
      </.form>
    </div>
    """
  end

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_demographic()
      |> assign_changeset()
    }
  end

  def handle_event("validate", %{"demographic" => demographic_params}, socket) do
    {
      :noreply,
      validate_demographic(socket, demographic_params)
    }
  end

  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    {:noreply, save_demographic(socket, demographic_params)}
  end

  def assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, %Demographic{user_id: current_user.id})
  end

  def assign_changeset(%{assigns: %{demographic: demographic}} = socket) do
    assign(socket, :changeset, Survey.change_demographic(demographic))
  end

  defp validate_demographic(socket, demographic_params) do
    changeset =
      socket.assigns.demographic
      |> Survey.change_demographic(demographic_params)
      |> Map.put(:action, :validate)

    assign(socket, :changeset, changeset)
  end

  defp save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end
end
