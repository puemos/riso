defmodule Riso.Positions.Stage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Positions.Position

  schema "stages" do
    field :title, :string
    belongs_to :position, Position

    timestamps()
  end

  @doc false
  def changeset(stage, attrs) do
    stage
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
