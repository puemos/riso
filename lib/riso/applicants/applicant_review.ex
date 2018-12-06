defmodule Riso.Applicants.ApplicantReview do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Positions.Position
  alias Riso.Applicants.Applicant
  alias Riso.Kpis.Kpi

  schema "applicants_reviews" do
    field :score, :integer
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
      :position_id,
      :kpi_id,
      :score
    ])
    |> unique_constraint(:applicants_reviews, name: :positions_kpis_position_id_kpi_id_index)
    |> validate_required([
      :applicant_id,
      :position_id,
      :kpi_id,
      :score
    ])
  end
end
