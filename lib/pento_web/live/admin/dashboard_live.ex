defmodule PentoWeb.Admin.DashboardLive do
  use PentoWeb, :live_view
  alias PentoWeb.Admin.{
    UserActivityLive,
    SurveyResultsLive,
    SurveyActivityLive
  }
  alias PentoWeb.Endpoint

  @survey_results_topic "survey_results"
  @user_activity_topic "user_activity"
  @survey_activity_topic "survey_activity"

  @impl true
  def render(assigns) do
    ~H"""
      <section class="row">
        <h1>Admin Dashboard</h1>
      </section>
      <.live_component
        module={PentoWeb.Admin.SurveyResultsLive}
        id={@survey_results_component_id}
      />
      <.live_component
        module={PentoWeb.Admin.UserActivityLive}
        id={@user_activity_component_id}
      />
      <.live_component
        module={PentoWeb.Admin.SurveyActivityLive}
        id={@survey_activity_component_id}
      />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
      Endpoint.subscribe(@user_activity_topic)
      Endpoint.subscribe(@survey_activity_topic)
    end

    {:ok,
      socket
      |> assign(:survey_results_component_id, "survey-results")
      |> assign(:user_activity_component_id, "user-activity")
      |> assign(:survey_activity_component_id, "survey-activity")}
  end

  @impl true
  def handle_info(%{event: "rating_created"}, socket) do
    send_update(SurveyResultsLive, id: socket.assigns.survey_results_component_id)
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    send_update(
      UserActivityLive,
      id: socket.assigns.user_activity_component_id)
    send_update(
      SurveyActivityLive,
      id: socket.assigns.survey_activity_component_id)
    {:noreply, socket}
  end
end
