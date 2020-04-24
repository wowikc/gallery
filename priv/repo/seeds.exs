# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Chirp.Repo.insert!(%Chirp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Chirp.Catalog

image_ids_data = [
  %{
    image_id: "photo-1562971179-4ad6903a7ed6"
  },
  %{
    image_id: "photo-1552673597-e3cd6747a996"
  },
  %{
    image_id: "photo-1561133036-61a7ed56b424"
  },
  %{
    image_id: "photo-1530717449302-271006cdc1bf"
  },
  %{
    image_id: "photo-1587589251866-c9c4aa6f2a52"
  },
  %{
    image_id: "photo-1587567853821-089af217cdd5"
  }
]

Enum.each(image_ids_data, fn data ->
  Catalog.create_image(data)
end)
