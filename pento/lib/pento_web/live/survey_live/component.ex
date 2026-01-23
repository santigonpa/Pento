defmodule PentoWeb.SurveyLive.Component do
  use Phoenix.Component

  attr :content, :string, required: true
  slot :inner_block, required: true

  def hero(assigns) do
    ~H"""
    <h1 class="font-heavy text-3xl">
      <%= @content %>
    </h1>
    <h3>
      <%= render_slot(@inner_block) %>
    </h3>
    """
  end

  attr(:title, :string, required: true)
  attr(:message, :string, required: false)

  def title(assigns) do
    ~H"""
    <div class="mb-4">
      <h2 class="font-bold text-3xl text-gray-800">
        <%= @title %>
      </h2>
      <p class="text-sm text-gray-600">
        <%= @message %>
      </p>
      <hr class="my-4 border-gray-300"/>
    </div>
    """
  end

  attr(:item, :any, required: true)

  def list_item(assigns) do
    ~H"""
    <li class="mb-2">
      <%= @item %>
    </li>
    """
  end

  attr(:items, :list, required: true)

  def list(assigns) do
    ~H"""
    <ul class="list-disc list-inside">
      <%= for item <- @items do %>
        <.list_item item={item} />
      <% end %>
    </ul>
    """
  end
end
