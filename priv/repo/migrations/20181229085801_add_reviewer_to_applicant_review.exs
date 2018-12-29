defmodule Riso.Repo.Migrations.AddReviewerToApplicantReview do
  use Ecto.Migration

  def change do
    alter table(:applicants_reviews) do
      add(:reviewer_id, references(:users, on_delete: :delete_all))
    end

    create(index(:applicants_reviews, [:reviewer_id]))
  end
end
