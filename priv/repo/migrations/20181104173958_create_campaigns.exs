defmodule Riso.Repo.Migrations.CreateCampaigns do
  use Ecto.Migration

  def change do
    create table(:campaigns) do
      add(:name, :string)

      timestamps(type: :utc_datetime)
    end
  end
end
