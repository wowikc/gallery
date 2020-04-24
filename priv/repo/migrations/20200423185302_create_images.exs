defmodule Chirp.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :image_id, :string

      timestamps()
    end
  end
end
