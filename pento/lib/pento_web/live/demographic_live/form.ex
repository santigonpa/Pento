defmodule PentoWeb.DemographicLive.Form do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Demographic
  alias PentoWeb.Presence

  def update(assigns, socket) do
    socket = assign(socket, assigns)

    maybe_track_user(socket)

    {
      :ok,
      socket
      |> assign_demographic()
      |> clear_form()
    }
  end

  defp maybe_track_user(%{assigns: %{current_user: current_user}} = socket) do
    if connected?(socket) do
      Presence.track_survey_user(self(), current_user.email)
    end
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    # assign a new demographic struct with user_id
    assign(socket, :demographic, %Demographic{user_id: current_user.id})
  end

  defp assign_form(socket, changeset) do
    # Convert changeset to form
    assign(socket, :form, to_form(changeset))
  end

  defp clear_form(%{assigns: %{demographic: demographic}} = socket) do
    # take empty demographic from the socket, wrap that in a changeset and then
    # add that to socket with assign_form
    assign_form(socket, Survey.change_demographic(demographic))
  end

  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    params = params_with_user_id(demographic_params, socket)
    {:noreply, save_demographic(socket, params)}
  end

  def params_with_user_id(params, %{assigns: %{current_user: current_user}}) do
    params
    |> Map.put("user_id", current_user.id)
  end

  defp save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
    end
  end
end
