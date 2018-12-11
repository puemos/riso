defmodule Riso.Organizations.OrganizationUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Accounts.User
  alias Riso.Organizations.Organization

  schema "organizations_users" do
    belongs_to :user, User
    belongs_to :organization, Organization

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization_user, attrs) do
    organization_user
    |> cast(attrs, [:organization_id, :user_id])
    |> unique_constraint(:organizations, name: :organizations_users_organization_id_user_id_index)
    |> validate_required([:organization_id, :user_id])
  end
end
