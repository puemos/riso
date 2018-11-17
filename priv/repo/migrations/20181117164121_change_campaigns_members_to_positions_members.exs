defmodule Riso.Repo.Migrations.ChangeCampaignsMembersToPositionsMembers do
  use Ecto.Migration

  def change do
    rename(table("campaigns_members"), to: table("positions_members"))
  end
end
