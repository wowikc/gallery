defmodule ChirpWeb.GalleryLive do
  use ChirpWeb, :live_view

  alias Chirp.Catalog
  alias Chirp.Catalog.Image
  alias Chirp.Gallery

  def mount(_session, _, socket) do
    new_current_id = Catalog.get_image_id(Gallery.first_image())

    {:ok,
     assign(socket, %{
       changeset: Catalog.change_image(%Image{}),
       current_id: new_current_id,
       slideshow: :stopped,
       five_ids: five_ids(new_current_id)
     })}
  end

  def handle_event("prev", _event, socket) do
    {:noreply, assign_prev_id(socket)}
  end

  def handle_event("next", _event, socket) do
    {:noreply, assign_next_id(socket)}
  end

  def handle_event("toggle_slideshow", _event, socket) do
    case socket.assigns.slideshow do
      :stopped ->
        {:ok, ref} = :timer.send_interval(2_000, self(), :slideshow_next)
        {:noreply, assign(socket, :slideshow, ref)}

      _ ->
        :timer.cancel(socket.assigns.slideshow)
        {:noreply, assign(socket, :slideshow, :stopped)}
    end
  end

  def handle_event("set_current", %{"id" => id}, socket) do
    {:noreply, assign(socket, :current_id, id)}
  end

  def handle_event("remove_image", _, socket) do
    prev_id = Gallery.prev_image_id(socket.assigns.current_id)

    socket.assigns.current_id
    |> Catalog.get_image_by_image_id()
    |> Catalog.delete_image()

    {:noreply,
     socket
     |> put_flash(:error, "Image deleted")
     |> assign(%{
       five_ids: five_ids(prev_id),
       current_id: prev_id
     })}
  end

  def handle_event("add_image_to_gallery", %{"image" => image}, socket) do
    image
    |> Catalog.create_image()
    |> case do
      {:ok, _image} ->
        {:noreply,
         socket
         |> put_flash(:info, "Image Added")
         |> assign(%{
           changeset: Catalog.change_image(%Image{}),
           five_ids: five_ids(socket.assigns.current_id)
         })}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(changeset: changeset)
         |> put_flash(:error, "Unable to Add unexisting image")}
    end
  end

  def handle_event("validate", %{"image" => image}, socket) do
    {_, %Ecto.Changeset{} = changeset} =
      %{image_id: image["image_id"]}
      |> Catalog.validate_form_input()

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_info(:slideshow_next, socket) do
    {:noreply, assign_next_id(socket)}
  end

  def assign_prev_id(socket) do
    socket = assign(socket, :current_id, Gallery.prev_image_id(socket.assigns.current_id))
    assign(socket, :five_ids, five_ids(socket.assigns.current_id))
  end

  def assign_next_id(socket) do
    socket = assign(socket, :current_id, Gallery.next_image_id(socket.assigns.current_id))
    assign(socket, :five_ids, five_ids(socket.assigns.current_id))
  end

  defp thumb_css_class(thumb_id, current_id) do
    if thumb_id == current_id do
      "thumb-selected"
    else
      "thumb-unselected"
    end
  end

  defp five_ids(current_id) do
    Gallery.five_related_id(current_id)
  end
end
