defmodule RisoWeb.Schema.OrganizationsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "A organization with name and content"
  object :organization do
    field(:id, :id)
    field(:name, :string)
    field(:inserted_at, :datetime)
    field(:members, list_of(:organization_member), resolve: dataloader(Riso.Accounts))
    field(:positions, list_of(:position), resolve: dataloader(Riso.Positions))
  end

  @desc "A memebr of a organization"
  object :organization_member do
    field(:id, :id)
    field(:user, :user, resolve: dataloader(Riso.Accounts))
    field(:role, :organization_memebr_role)
    field(:inserted_at, :datetime)
  end

  enum :organization_memebr_role do
    description("The organization member role")

    value(:editor, as: "editor", description: "Can edit and view the organization")
    value(:viewer, as: "viewer", description: "Can view the organization")
  end
end
