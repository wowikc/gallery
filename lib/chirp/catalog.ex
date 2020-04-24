defmodule Chirp.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias Chirp.Catalog.Image
  alias Chirp.Repo

  def get_image!(id), do: Repo.get!(Image, id)

  def create_image(attrs \\ %{}) do
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

  def get_image_by_image_id(image_id) do
    Enum.find(list_images(), &(&1.image_id == image_id))
  end

  def delete_image(%Image{} = image) do
    Repo.delete(image)
  end

  def change_image(%Image{} = image) do
    Image.changeset(image, %{})
  end

  def list_images do
    Image
    |> Repo.all()
  end

  def get_image_id(%Image{} = image) do
    image.image_id
  end

  def validate_form_input(attrs) do
    %Image{}
    |> change(attrs)
    |> Image.validate_form_input()
  end
end
