defmodule Riso.Applicants.Applicant do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Positions.{PositionStage}

  schema "applicants" do
    field :name, :string
    belongs_to :stage, PositionStage, foreign_key: :position_stage_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(applicant, attrs) do
    applicant
    |> cast(attrs, [:name, :position_stage_id])
    |> unique_constraint(:name)
    |> validate_required([:name])
  end
end
