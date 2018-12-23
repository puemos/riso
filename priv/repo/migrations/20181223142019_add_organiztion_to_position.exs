defmodule Riso.Repo.Migrations.AddOrganiztionToPosition do
  use Ecto.Migration

  def change do
    alter table(:positions) do
      add(:organization_id, references(:organizations, on_delete: :delete_all))
    end

    create(index(:positions, [:organization_id]))
  end
end
