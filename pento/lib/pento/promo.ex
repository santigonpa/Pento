defmodule Pento.Promo do
  alias Pento.Promo.Recipient
  alias Pento.Accounts.UserNotifier

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(recipient, attrs) do
    case change_recipient(recipient, attrs) do
      %{valid?: true} = changeset ->
        UserNotifier.deliver_promotion(changeset.changes)

        {:ok, %Recipient{}}

      changeset ->
        {:error, changeset}
    end
  end
end
