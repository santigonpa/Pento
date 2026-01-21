defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view
  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_recipient()
     |> clear_form()}
  end

  def assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  def clear_form(socket) do
    form =
      socket.assigns.recipient
      |> Promo.change_recipient()
      |> to_form()

    assign(socket, :form, form)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def handle_event(
        "validate",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    changeset =
      recipient
      # Create changeset with new params
      |> Promo.change_recipient(recipient_params)
      # ensures that we display only feedback for form fields that have received input
      |> Map.put(:action, :validate)

    # Update form with changeset
    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event(
        "save",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    # :timer.sleep(1000)

    case Promo.send_promo(recipient, recipient_params) do
      {:ok, _recipient} ->
        {:noreply,
         socket
         |> put_flash(:info, "Promo sent successfully!")
         # reset recipient
         |> assign_recipient()
         # clear form
         |> clear_form()}

      {:error, changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to send promo. Please check the errors below.")
         |> assign(:form, to_form(changeset, action: :validate))}
    end
  end
end
