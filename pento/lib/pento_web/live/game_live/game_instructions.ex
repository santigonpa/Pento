defmodule PentoWeb.GameLive.GameInstructions do
  use Phoenix.Component

  def show(assigns) do
    ~H"""
    <div class="instructions text-gray-600">
      <h2 class="font-heavy text-xl">How to Play</h2>
      <ul class="list-disc list-inside text-sm">
        <li>Select a pentomino from the palette below the board.</li>
        <li>Choose a location on the board to place the pentomino.</li>
        <li>Fit all pentominoes onto the board to complete the puzzle!</li>
      </ul>
    </div>
    """
  end
end
