defmodule PentoWeb.SurveyLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Pento.{Accounts, Survey, Catalog}

  @create_user_attrs %{email: "test@test.com", password: "passwordpassword"}
  @create_demographic_attrs %{
    gender: "female",
    year_of_birth: DateTime.utc_now().year - 25,
    education_level: "other"
  }

  defp user_fixture(attrs \\ @create_user_attrs) do
    {:ok, user} = Accounts.register_user(attrs)
    user
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  describe "Survey Live View" do
    setup [:register_and_log_in_user, :create_user]

    test "submitting demographic form updates to show saved details", %{conn: conn} do
      {:ok, view, html} = live(conn, "/survey")

      assert html =~ "Please fill out our survey"
      assert has_element?(view, "#demographic-form")

      params = %{"demographic" => @create_demographic_attrs}

      view
      |> element("#demographic-form")
      |> render_submit(params)

      :timer.sleep(2)

      updated_html = render(view)

      assert updated_html =~ "Demographics ✓"
      assert updated_html =~ "female"
      assert updated_html =~ "25"
      assert updated_html =~ "other"
    end
  end
end
