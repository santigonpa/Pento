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

  defp rating_fixture(user, product, stars) do
    {:ok, rating} =
      Survey.create_rating(%{
        stars: stars,
        user_id: user.id,
        product_id: product.id
      })

    rating
  end

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_rating(user, product, stars) do
    rating = rating_fixture(user, product, stars)
    %{rating: rating}
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

    test "renders the correct rating details when ratings do exist",
         %{user: user, product: product} do
      # create a rating for the user and product
      %{rating: rating} = create_rating(user, product, 2)
      product = %{product | ratings: [rating]}

      rendered =
        render_component(&Index.product_list/1, %{
          products: [product],
          current_user: user
        })

      # 2 filled stars and 3 unfilled stars
      assert rendered =~ "&#x2605; &#x2605; &#x2606; &#x2606; &#x2606;"

      # ensure the rating form is not rendered
      refute rendered =~ "rating-form-#{product.id}"
    end
  end
end
