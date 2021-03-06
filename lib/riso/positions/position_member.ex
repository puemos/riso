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

    timestamps(type: :utc_datetime)
  end

  def options(), do: @options
  def default_values(), do: @default_values

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :position_id, :role])
    |> validate_inclusion(:role, @options[:role])
    |> unique_constraint(:role, name: :positions_members_position_id_user_id_index)
    |> validate_required([:user_id, :position_id, :role])
  end
end
