defmodule Riso.Organizations.OrganizationMember do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Accounts.User
  alias Riso.Organizations.Organization

  @options %{
    role: ["viewer", "editor"]
  }
  @default_values %{
    role: "viewer"
  }

  schema "organizations_members" do
    field :role, :string

    belongs_to :user, User
    belongs_to :organization, Organization

    timestamps(type: :utc_datetime)
  end

  def options(), do: @options
  def default_values(), do: @default_values

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :organization_id, :role])
    |> validate_inclusion(:role, @options[:role])
    |> unique_constraint(:role, name: :organizations_members_organization_id_user_id_role_index)
    |> validate_required([:user_id, :organization_id, :role])
  end
end
