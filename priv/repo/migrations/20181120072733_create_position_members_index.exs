defmodule Riso.Repo.Migrations.CreatePositionMembersIndex do
  use Ecto.Migration

  def change do
    create(unique_index(:positions_members, [:position_id, :user_id, :role]))
  end
end
