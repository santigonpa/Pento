defmodule Pento.Search.SkuSearch do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key false

  embedded_schema do
    field(:sku, :string)
  end

  def changeset(sku_search, attrs) do
    sku_search
    |> cast(attrs, [:sku])
    |> validate_required([:sku])
    |> validate_length(:sku, min: 7)
  end
end
