defmodule Riso.Repo.Migrations.ChangeCampaignsToPositions do
  use Ecto.Migration

  def change do
    rename(table("campaigns"), to: table("positions"))
  end
end
