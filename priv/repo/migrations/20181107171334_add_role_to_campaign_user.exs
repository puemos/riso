defmodule Riso.Repo.Migrations.AddRoleToCampaignUser do
  use Ecto.Migration

  def change do
    alter table(:campaigns_users) do
      add(:role, :string)
    end
  end
end
