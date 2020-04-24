defmodule Chirp.Catalog.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :image_id, :string

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:image_id])
    |> validate_required([:image_id])
    |> validate_format(:image_id, ~r{\Aphoto-[a-z0-9]+-[a-z0-9]+$})
  end

  def validate_form_input(%Ecto.Changeset{changes: %{image_id: id}} = changeset) do
    validate_image_id(id)
    |> case do
      false ->
        {:error,
         changeset
         |> Map.put(:action, :insert)
         |> add_error(:image_id, "Image id is not valid")}

      _ ->
        {:ok, changeset}
    end
  end

  defp validate_image_id(""), do: :ok
  defp validate_image_id(id), do: String.match?(id, ~r{\Aphoto-[a-z0-9]+-[a-z0-9]+$})
end
