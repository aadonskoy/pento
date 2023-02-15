defmodule PentoWeb.Admin.DashboardLive do
  use PentoWeb, :live_view

  def render(assigns) do
    ~H"""
      <section class="row">
        <h1>Admin Dashboard</h1>
      </section>
      <.live_component
        module={PentoWeb.Admin.SurveyResultsLive}
        id={@survey_results_component_id}
      />
    """
  end

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:survey_results_component_id, "survey-results")
    }
  end
end
