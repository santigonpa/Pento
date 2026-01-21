defmodule PentoWeb.SearchLive do
  use PentoWeb, :live_view

  alias Pento.Search
  alias Pento.Search.SkuSearch

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:products, [])
     |> assign_sku_search()
     |> clear_form()}
  end

  def assign_sku_search(socket) do
    socket
    |> assign(:sku_search, %SkuSearch{})
  end

  def clear_form(socket) do
    form =
      socket.assigns.sku_search
      |> Search.change_sku_search()
      |> to_form()

    assign(socket, :form, form)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def handle_event(
        "search",
        %{"sku_search" => sku_search_params},
        %{assigns: %{sku_search: sku_search}} = socket
      ) do
    changeset =
      sku_search
      |> Search.change_sku_search(sku_search_params)

    if changeset.valid? do
      sku = get_in(sku_search_params, ["sku"])
      products = Search.get_products(sku)

      {:noreply,
       socket
       |> assign(:form, to_form(changeset, action: :validate))
       |> stream(:products, products, reset: true)}
    else
      {:noreply,
       socket
       |> assign(:form, to_form(changeset, action: :validate))}
    end
  end
end
