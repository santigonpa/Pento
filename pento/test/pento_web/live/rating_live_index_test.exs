defmodule PentoWeb.RatingLiveIndexTest do
  use PentoWeb.ConnCase

  import Phoenix.Component
  import Phoenix.LiveViewTest

  alias PentoWeb.RatingLive.Index
  alias Pento.{Accounts, Survey, Catalog}

  @create_product_attrs %{
    description: "test description",
    name: "Test Game",
    sku: 42,
    unit_price: 120.5
  }
  @create_user_attrs %{email: "test@test.com", password: "passwordpassword"}

  defp product_fixture do
    {:ok, product} = Catalog.create_product(@create_product_attrs)
    product
  end

  defp user_fixture(attrs \\ @create_user_attrs) do
    {:ok, user} = Accounts.register_user(attrs)
    user
  end

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  describe "Index" do
    setup [:create_product, :create_user]

    setup %{user: user, product: product} do
      # ensure product has no ratings
      product = %{product | ratings: []}
      %{user: user, product: product}
    end

    test "renders the product rating form when no product rating exists",
         %{user: user, product: product} do
      rendered =
        render_component(&Index.product_list/1, %{
          products: [product],
          current_user: user
        })

      # assert it includes the rating form since no ratings exist
      assert rendered =~ "rating-form-#{product.id}"
    end
  end
end
