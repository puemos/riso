defmodule Riso.Repo.Migrations.CreateApplicants do
  use Ecto.Migration

  def change do
    create table(:applicants) do
      add :name, :string
      add :position_stage_id, references(:positions_stages, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:applicants, [:name])
    create index(:applicants, [:position_stage_id])
  end
end
