defmodule Pento.Survey.Demographic do
  use Ecto.Schema

  alias Pento.Accounts.User

  import Ecto.Changeset

  schema "demographics" do
    field :gender, :string
    field :year_of_birth, :integer
    field :education_level, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(demographic, attrs) do
    demographic
    |> cast(attrs, [:gender, :year_of_birth, :user_id, :education_level])
    |> validate_required([:gender, :year_of_birth, :user_id, :education_level])
    |> validate_inclusion(
      :gender,
      ["male",
      "female",
      "other",
      "prefer not to say"]
      )
    |> validate_inclusion(
      :education_level,
      ["high school",
      "bachelor's degree",
      "graduate degree",
      "other",
      "prefer not to say"]
      )
    |> validate_inclusion(:year_of_birth, 1920..2026)
    |> unique_constraint(:user_id)
  end
end
