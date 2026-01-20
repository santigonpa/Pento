defmodule Pento.Promo.Recipient do
  use Ecto.Schema
  import Ecto.Changeset
  # Since this is an embedded schema, we don't need a primary key
  @primary_key false

  # We use embedded_schema for non-persistent data structures
  embedded_schema do
    field(:first_name, :string)
    field(:email, :string)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :email])
    # Ensure both fields are present
    |> validate_required([:first_name, :email])
    # Basic email format validation
    |> validate_format(:email, ~r/@/)
  end
end
