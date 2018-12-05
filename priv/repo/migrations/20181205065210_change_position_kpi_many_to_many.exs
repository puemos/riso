defmodule Riso.Repo.Migrations.ChangePositionKpiManyToMany do
  use Ecto.Migration

  def change do
    alter table(:positions_kpis) do
      remove(:title)
      add(:kpi_id, references(:kpis, on_delete: :delete_all))
    end

    drop(index(:positions_kpis, [:position_id]))
    create(unique_index(:positions_kpis, [:position_id, :kpi_id]))
  end
end
