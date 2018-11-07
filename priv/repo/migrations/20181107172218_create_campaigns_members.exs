defmodule Riso.Repo.Migrations.CreateCampaignsMembers do
  use Ecto.Migration

  def change do
    create table(:campaigns_members) do
      add(:role, :string)
      add(:campaign_id, references(:campaigns, on_delete: :delete_all))
      add(:user_id, references(:users, on_delete: :delete_all))

      timestamps()
    end

    create(index(:campaigns_members, [:campaign_id, :user_id]))
  end
end
