defmodule Riso.Positions.Position do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Positions.{PositionMember, PositionStage, PositionKpi}

  @options %{}
  @default_values %{}

  schema "positions" do
    field :title, :string

    has_many :stages, PositionStage
    has_many :kpis, PositionKpi
    has_many :members, PositionMember

    timestamps()
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
