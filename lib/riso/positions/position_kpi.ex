defmodule Riso.Positions.PositionKpi do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Positions.Position
  alias Riso.Kpis.Kpi

  schema "positions_kpis" do
    belongs_to :position, Position
    belongs_to :kpi, Kpi

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(position_kpi, attrs) do
    position_kpi
    |> cast(attrs, [:kpi_id, :position_id])
    |> validate_required([:kpi_id, :position_id])
  end
end
