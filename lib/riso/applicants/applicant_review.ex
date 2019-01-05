defmodule Riso.Applicants.ApplicantReview do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Accounts.{User}
  alias Riso.Positions.{Position}
  alias Riso.Applicants.{Applicant}
  alias Riso.Kpis.{Kpi}

  schema "applicants_reviews" do
    field :score, :integer
    belongs_to :reviewer, User, foreign_key: :reviewer_id
    belongs_to :applicant, Applicant, foreign_key: :applicant_id
    belongs_to :position, Position, foreign_key: :position_id
    belongs_to :kpi, Kpi, foreign_key: :kpi_id

    timestamps()
  end

  @doc false
  def changeset(applicant_review, attrs) do
    applicant_review
    |> cast(attrs, [
      :applicant_id,
      :reviewer_id,
      :position_id,
      :kpi_id,
      :score
    ])
    |> foreign_key_constraint(:applicant, name: :applicants_reviews_applicant_id_fkey)
    |> foreign_key_constraint(:position, name: :applicants_reviews_position_id_fkey)
    |> foreign_key_constraint(:reviewer, name: :applicants_reviews_reviewer_id_fkey)
    |> foreign_key_constraint(:kpi, name: :applicants_reviews_kpi_id_fkey)
    |> unique_constraint(:applicants_reviews,
      name: :applicants_reviews_applicant_id_kpi_id_position_id_index,
      message: "The applicant has been already review for that kpi"
    )
    |> validate_required([
      :applicant_id,
      :reviewer_id,
      :position_id,
      :kpi_id,
      :score
    ])
  end
end
