defmodule RisoWeb.Schema.OrganizationsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "A organization with name and content"
  object :organization do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:inserted_at, non_null(:datetime))
    field(:members, non_null(list_of(:organization_member)), resolve: dataloader(Riso.Accounts))
    field(:positions, non_null(list_of(:position)), resolve: dataloader(Riso.Positions))
  end

  @desc "A memebr of a organization"
  object :organization_member do
    field(:id, non_null(:id))
    field(:user, non_null(:user), resolve: dataloader(Riso.Accounts))
    field(:role, non_null(:organization_memebr_role))
    field(:inserted_at, non_null(:datetime))
  end

  enum :organization_memebr_role do
    description("The organization member role")

    value(:editor, as: "editor", description: "Can edit and view the organization")
    value(:viewer, as: "viewer", description: "Can view the organization")
  end
end
