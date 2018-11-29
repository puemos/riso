defmodule Riso.Positions.PositionKpi do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Positions.Position

  schema "positions_kpis" do
    field :title, :string
    belongs_to :position, Position

    timestamps()
  end

  @doc false
  def changeset(position_kpi, attrs) do
    position_kpi
    |> cast(attrs, [:title, :position_id])
    |> validate_required([:title, :position_id])
  end
end
