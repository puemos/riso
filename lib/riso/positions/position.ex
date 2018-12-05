defmodule Riso.Positions.Position do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Kpis.Kpi
  alias Riso.Positions.{PositionMember, PositionStage, PositionKpi}

  @options %{}
  @default_values %{}

  schema "positions" do
    field :title, :string

    has_many :stages, PositionStage
    has_many :members, PositionMember
    many_to_many :kpis, Kpi, join_through: PositionKpi

    timestamps(type: :utc_datetime)
  end

  def options(), do: @options
  def default_values(), do: @default_values

  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
