defmodule Riso.Repo.Migrations.RemoveCampaignsUsers do
  use Ecto.Migration

  def change do
    drop(table("campaigns_users"))
  end
end
