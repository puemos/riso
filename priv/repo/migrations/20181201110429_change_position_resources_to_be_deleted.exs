defmodule Riso.Repo.Migrations.ChangePositionResourcesToBeDeleted do
  use Ecto.Migration

  def change do
    drop(constraint(:positions_stages, "stages_position_id_fkey"))
    alter table(:positions_stages) do
      modify(:position_id, references(:positions, on_delete: :delete_all))
    end

    drop(constraint(:positions_members, "positions_members_position_id_fkey"))
    alter table(:positions_members) do
      modify(:position_id, references(:positions, on_delete: :delete_all))
    end
  end
end
