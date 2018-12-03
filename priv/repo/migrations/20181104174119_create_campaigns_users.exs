defmodule Riso.Repo.Migrations.CreateCampaignsUsers do
  use Ecto.Migration

  def change do
    create table(:campaigns_users) do
      add(:campaign_id, references(:campaigns, on_delete: :nothing))
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps(type: :utc_datetime)
    end

    create(index(:campaigns_users, [:campaign_id]))
    create(index(:campaigns_users, [:user_id]))
  end
end
