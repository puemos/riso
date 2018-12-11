defmodule Riso.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Accounts.User
  alias Riso.Organizations.OrganizationUser

  schema "organizations" do
    field :name, :string
    many_to_many :members, User, join_through: OrganizationUser

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
