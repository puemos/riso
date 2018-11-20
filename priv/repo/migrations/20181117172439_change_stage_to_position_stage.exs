defmodule Riso.Repo.Migrations.ChangeStageToPositionStage do
  use Ecto.Migration

  def change do
    rename(table("stages"), to: table("positions_stages"))
  end
end
