defmodule Riso.Repo.Migrations.CreateApplicantsReviews do
  use Ecto.Migration

  def change do
    create table(:applicants_reviews) do
      add(:kpi_id, references(:kpis, on_delete: :delete_all))
      add(:position_id, references(:positions, on_delete: :delete_all))
      add(:applicant_id, references(:applicants, on_delete: :delete_all))
      add(:score, :integer)
      timestamps(type: :utc_datetime)
    end

    create(unique_index(:applicants_reviews, [:applicant_id, :kpi_id, :position_id]))
    create(index(:applicants_reviews, [:kpi_id]))
    create(index(:applicants_reviews, [:position_id]))
    create(index(:applicants_reviews, [:applicant_id]))
  end
end
