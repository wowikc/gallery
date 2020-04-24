defmodule Chirp.Gallery do
  alias Chirp.Catalog

  @unsplash_url "https://images.unsplash.com"

  def image_ids, do: Catalog.list_images()

  def image_url(image_id, params) do
    URI.parse(@unsplash_url)
    |> URI.merge(image_id)
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  def thumb_url(id),
    do: image_url(id, %{w: 100, h: 100, fit: "crop"})

  def large_url(id),
    do: image_url(id, %{h: 500, fit: "crop"})

  def first_image(ids \\ image_ids()), do: List.first(ids)

  def next_image_id(ids \\ image_ids(), id) do
    Catalog.get_image_id(Enum.at(ids, next_index(ids, id), first_image(ids)))
  end

  defp next_index(ids, id) do
    ids
    |> Enum.find_index(&(&1.image_id == id))
    |> Kernel.+(1)
  end

  def prev_image_id(ids \\ image_ids(), id) do
    Catalog.get_image_id(Enum.at(ids, prev_index(ids, id)))
  end

  defp prev_index(ids, id) do
    ids
    |> Enum.find_index(&(&1.image_id == id))
    |> Kernel.-(1)
  end

  def five_related_id(ids \\ image_ids(), id) do
    index = Enum.find_index(ids, &(&1.image_id == id))

    [
      Catalog.get_image_id(Enum.at(ids, index - 2)),
      Catalog.get_image_id(Enum.at(ids, index - 1)),
      Catalog.get_image_id(Enum.at(ids, index)),
      Catalog.get_image_id(Enum.at(ids, circular_index(ids, index + 1))),
      Catalog.get_image_id(Enum.at(ids, circular_index(ids, index + 2)))
    ]
  end

  defp circular_index(ids, index) do
    rem(index, length(ids))
  end
end
