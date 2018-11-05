defmodule Riso.Repo.Migrations.ChangeCampaignNameToTitle do
  use Ecto.Migration

  def change do
    rename(table("campaigns"), :name, to: :title)
  end
end
