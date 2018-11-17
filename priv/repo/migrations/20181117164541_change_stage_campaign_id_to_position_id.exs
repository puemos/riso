defmodule Riso.Repo.Migrations.ChangeStageCampaignIdToPositionId do
  use Ecto.Migration

  def change do
    alter table("stages") do
      add(:position_id, references("positions"))
      remove(:campaign_id)
    end
    alter table("positions_members") do
      add(:position_id, references("positions"))
      remove(:campaign_id)
    end
  end
end
