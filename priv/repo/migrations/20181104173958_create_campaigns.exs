defmodule Riso.Repo.Migrations.CreateCampaigns do
  use Ecto.Migration

  def change do
    create table(:campaigns) do
      add :name, :string

      timestamps()
    end

  end
end
