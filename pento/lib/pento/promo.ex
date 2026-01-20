defmodule Pento.Promo do
  alias Pento.Promo.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def sent_promo(recipient, attrs) do
    case change_recipient(recipient, attrs) do
      %{valid?: true} = changeset ->
        # todo actually send promo (e.g., via email)
        {:ok, %Recipient{}}

      changeset ->
        {:error, changeset}
    end
  end
end
