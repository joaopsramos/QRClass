defmodule QRClassWeb.ClassLive.QRCode do
  use QRClassWeb, :live_component

  alias QRCode.Render.SvgSettings
  alias QRClass.Course

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        QR Code de presença
        <div>
          <%= if @class_session.qr_code_active do %>
            <button
              phx-click="inactive-qr-code"
              phx-target={@myself}
              class="py-2 px-3 rounded-lg text-sm text-white font-semibold leading-6 mt-4 bg-red-600 hover:bg-red-700"
            >
              Desativar
            </button>
          <% else %>
            <button
              phx-click="active-qr-code"
              phx-target={@myself}
              class="py-2 px-3 rounded-lg text-sm text-white font-semibold leading-6 mt-4 bg-green-600 hover:bg-green-700"
            >
              Ativar
            </button>
          <% end %>

          <img class="mt-8 mx-auto" src={"data:image/svg+xml; base64, #{@qr_code}"} alt="" />
        </div>
      </.header>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, qr_code} =
      ~p"/attendance?token=#{Base.encode64(assigns.class_session.id)}"
      |> url()
      |> IO.inspect()
      |> QRCode.create()
      |> QRCode.render(:svg, get_svg_settings())
      |> QRCode.to_base64()

    {:ok, socket |> assign(assigns) |> assign(qr_code: qr_code)}
  end

  def handle_event("active-qr-code", _params, socket) do
    {:ok, class_session} = Course.active_qr_code(socket.assigns.class_session)

    {:noreply, assign(socket, :class_session, class_session)}
  end

  def handle_event("inactive-qr-code", _params, socket) do
    class_session = Course.inactive_qr_code(socket.assigns.class_session)

    {:noreply, assign(socket, :class_session, class_session)}
  end

  @impl true
  def handle_event("validate", %{"class" => class_params}, socket) do
    changeset =
      socket.assigns.class
      |> Course.change_class(class_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"class" => class_params}, socket) do
    save_class(socket, socket.assigns.action, class_params)
  end

  defp save_class(socket, :edit, class_params) do
    case Course.update_class(socket.assigns.class, class_params) do
      {:ok, class} ->
        notify_parent({:saved, class})

        {:noreply,
         socket
         |> put_flash(:info, "Class updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_class(socket, :new, class_params) do
    case Course.create_class(class_params) do
      {:ok, class} ->
        notify_parent({:saved, class})

        {:noreply,
         socket
         |> put_flash(:info, "Class created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp get_svg_settings do
    %SvgSettings{qrcode_color: "#279cf9", image: {"priv/static/images/anima-logo.png", 150}}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
