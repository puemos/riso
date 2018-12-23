defmodule Riso.Repo.Migrations.AddUniqueIndexToPositionMemberRole do
  use Ecto.Migration

  def change do
    drop_if_exists(unique_index(:positions_members, [:position_id, :user_id, :role]))
    create(unique_index(:positions_members, [:position_id, :user_id]))
  end
end
