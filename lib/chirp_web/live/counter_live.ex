defmodule ChirpWeb.CounterLive do
  use ChirpWeb, :live_view

  def mount(_session, _, socket) do
    {:ok, assign(socket, %{msg: "none", counter: 0})}
  end

  def handle_event("keydown", %{"key" => key}, socket) do
    {:noreply, assign(socket, msg: key)}
  end

  def handle_event("incr", _value, socket) do
    {:noreply, update(socket, :counter, &(&1 + 1))}
  end
end
