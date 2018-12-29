defmodule Riso.Repo.Migrations.AddPositionToApplicant do
  use Ecto.Migration

  def change do
    alter table(:applicants) do
      add(:position_id, references(:positions, on_delete: :delete_all))
    end

    create(index(:applicants, [:position_id]))
  end
end
