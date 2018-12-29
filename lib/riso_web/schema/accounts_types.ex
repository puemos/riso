defmodule RisoWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "An user entry, returns basic user information"
  object :user do
    field(:id, non_null(:id))
    field(:email, non_null(:string))
    field(:name, non_null(:string))
    field(:positions, non_null(list_of(:position)), resolve: dataloader(Riso.Positions))
    field(:organizations, non_null(list_of(:organization)), resolve: dataloader(Riso.Organizations))
  end

  @desc "token to authenticate user"
  object :session do
    field(:token, non_null(:string))
  end
end
