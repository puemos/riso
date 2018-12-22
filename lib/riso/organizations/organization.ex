defmodule Riso.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Accounts.User
  alias Riso.Organizations.OrganizationMember

  schema "organizations" do
    field :name, :string
    has_many :members, OrganizationMember

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
