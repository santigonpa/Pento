defmodule PentoWeb.RedirectWrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, redirect(socket, to: ~p"/guess")}
  end
end
