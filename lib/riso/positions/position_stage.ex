defmodule Riso.Positions.PositionStage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Positions.Position
  alias Riso.Applicants.{Applicant}

  schema "positions_stages" do
    field :title, :string
    belongs_to :position, Position
    has_many :applicants, Applicant

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(position_stage, attrs) do
    position_stage
    |> cast(attrs, [:title, :position_id])
    |> validate_required([:title, :position_id])
  end
end
