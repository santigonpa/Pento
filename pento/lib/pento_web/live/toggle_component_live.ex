defmodule PentoWeb.ToggleComponentLive do
  use PentoWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <.button class="mb-4" phx-click="toggle" phx-target={@myself}>
        <%= if @toggled do %>
          - Contract
        <% else %>
          + Expand
        <% end %>
      </.button>

      <%= if @toggled do %>
        <div>
          <%= render_slot(@inner_block) %>
        </div>
      <% end %>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:toggled, false)}
  end

  @impl true
  def handle_event("toggle", _params, socket) do
    {:noreply, assign(socket, toggled: !socket.assigns.toggled)}
  end
end
