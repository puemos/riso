defmodule Riso.Repo.Migrations.CreatePositionsKpis do
  use Ecto.Migration

  def change do
    create table(:positions_kpis) do
      add(:title, :string)
      add(:position_id, references(:positions, on_delete: :delete_all))

      timestamps()
    end

    create(index(:positions_kpis, [:position_id]))
  end
end
