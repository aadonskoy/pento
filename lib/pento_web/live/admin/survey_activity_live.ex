defmodule PentoWeb.Admin.SurveyActivityLive do
  use PentoWeb, :live_component
  alias PentoWeb.Presence

  @impl true
  def render(assigns) do
    ~H"""
      <div class="survey-activity-component">
        <h2>Survey Users</h2>
        <p><%= @survey_activity %> active users currently on survey</p>
      </div>
    """
  end

  @impl true
  def update(_assigns, socket) do
    {:ok,
     socket
     |> assign_survey_activity()}
  end

  def assign_survey_activity(socket) do
    assign(socket, :survey_activity, Presence.survey_users_amount())
  end
end
