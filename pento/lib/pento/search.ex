defmodule Pento.Search do
  alias Pento.Search.SkuSearch
  alias Pento.Catalog

  def change_sku_search(%SkuSearch{} = sku_search, attrs \\ %{}) do
    SkuSearch.changeset(sku_search, attrs)
  end

  def get_products(sku) do
    Catalog.get_products_by_string_sku(sku)
  end
end
