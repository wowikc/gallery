defmodule Gallery do
  @unsplash_url "https://images.unsplash.com"

  @ids [
    "photo-1562971179-4ad6903a7ed6",
    "photo-1552673597-e3cd6747a996",
    "photo-1561133036-61a7ed56b424",
    "photo-1530717449302-271006cdc1bf",
    "photo-1587589251866-c9c4aa6f2a52",
    "photo-1587567853821-089af217cdd5"
  ]

  def image_ids, do: @ids

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

  def first_id(ids \\ @ids), do: List.first(ids)

  def next_image_id(ids \\ @ids, id) do
    Enum.at(ids, next_index(ids, id), first_id(ids))
  end

  defp next_index(ids, id) do
    ids
    |> Enum.find_index(&(&1 == id))
    |> Kernel.+(1)
  end

  def prev_image_id(ids \\ @ids, id) do
    Enum.at(ids, prev_index(ids, id))
  end

  defp prev_index(ids, id) do
    ids
    |> Enum.find_index(&(&1 == id))
    |> Kernel.-(1)
  end

  def five_related_id(ids \\ @ids, id) do
    index = Enum.find_index(ids, &(&1 == id))

    [
      Enum.at(ids, index - 2),
      Enum.at(ids, index - 1),
      Enum.at(ids, index),
      Enum.at(ids, circular_index(ids, index + 1)),
      Enum.at(ids, circular_index(ids, index + 2))
    ]
  end

  defp circular_index(ids, index) do
    rem(index, length(ids))
  end
end
