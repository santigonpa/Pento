defmodule PentoWeb.Admin.SurveyActivityLive do
  use PentoWeb, :live_component

  alias PentoWeb.Presence

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_survey_users()}
  end

  def assign_survey_users(socket) do
    assign(socket, :survey_users, Presence.list_survey_users())
  end
end
