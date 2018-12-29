defmodule Riso.Applicants.Applicant do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Positions.{Position, PositionStage}
  alias Riso.Applicants.ApplicantReview

  schema "applicants" do
    field :name, :string
    belongs_to :position, Position, foreign_key: :position_id
    belongs_to :stage, PositionStage, foreign_key: :position_stage_id
    has_many :reviews, ApplicantReview

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(applicant, attrs) do
    applicant
    |> cast(attrs, [:name, :position_id, :position_stage_id])
    |> foreign_key_constraint(:stage, name: :applicants_position_stage_id_fkey)
    |> foreign_key_constraint(:stage, name: :applicants_position_id_fkey)
    |> unique_constraint(:name)
    |> validate_required([:name])
  end
end
