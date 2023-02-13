defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias PentoWeb.DemographicLive

  def render(assigns) do
    ~H"""
      <section class="row">
        <h2>Survey</h2>
      </section>
      <section class="row">
        <%= if @demographic do %>
            <DemographicLive.Show.details demographic={@demographic} />
        <% else %>
          <.live_component module={DemographicLive.Form} id="demographic-form" current_user={@current_user} />
        <% end %>
      </section>
    """
  end

  def mount(_params, _sessions, socket) do
    {
      :ok,
      socket
      |> assign_demographic()
    }
  end

  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_create(socket, demographic)}
  end

  def handle_demographic_create(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(
      socket,
      :demographic,
      Pento.Survey.get_demographic_by_user(current_user)
    )
  end
end
