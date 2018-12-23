defmodule RisoWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "An user entry, returns basic user information"
  object :user do
    field(:id, :id)
    field(:name, :string)
    field(:email, :string)
    field(:positions, list_of(:position), resolve: dataloader(Riso.Positions))
    field(:organizations, list_of(:organization), resolve: dataloader(Riso.Organizations))
  end

  @desc "token to authenticate user"
  object :session do
    field(:token, :string)
  end
end
