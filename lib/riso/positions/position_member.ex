defmodule Riso.Positions.PositionMember do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Positions.Position
  alias Riso.Accounts.User

  @options %{
    role: ["viewer", "editor"]
  }
  @default_values %{
    role: "viewer"
  }

  schema "positions_members" do
    field :role, :string

    belongs_to :user, User
    belongs_to :position, Position

    timestamps()
  end

  def options(), do: @options
  def default_values(), do: @default_values

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :position_id, :role])
    |> validate_inclusion(:role, @options[:role])
    |> validate_required([:user_id, :position_id, :role])
  end
end
