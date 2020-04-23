defmodule ChirpWeb.GalleryLive do
  use ChirpWeb, :live_view

  def mount(_session, _, socket) do
    {:ok, assign(socket, %{current_id: Gallery.first_id(), slideshow: :stopped})}
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
    Gallery.five_related_id(id)
    {:noreply, assign(socket, :current_id, id)}
  end

  def handle_info(:slideshow_next, socket) do
    {:noreply, assign_next_id(socket)}
  end

  def assign_prev_id(socket) do
    assign(socket, :current_id, Gallery.prev_image_id(socket.assigns.current_id))
  end

  def assign_next_id(socket) do
    assign(socket, :current_id, Gallery.next_image_id(socket.assigns.current_id))
  end

  defp thumb_css_class(thumb_id, current_id) do
    if thumb_id == current_id do
      "thumb-selected"
    else
      "thumb-unselected"
    end
  end

  def five_ids(current_id) do
    Gallery.five_related_id(current_id)
  end
end
