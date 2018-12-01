defmodule Riso.Applicants.Applicant do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Positions.{Position, PositionStage}

  schema "applicants" do
    field :name, :string
    belongs_to :position, Position
    belongs_to :position_stage, PositionStage

    timestamps()
  end

  @doc false
  def changeset(applicant, attrs) do
    applicant
    |> cast(attrs, [:name, :position_id, :position_stage_id])
    |> unique_constraint(:name)
    |> validate_required([:name])
  end
end
