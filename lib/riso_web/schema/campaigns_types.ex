defmodule RisoWeb.Schema.CampaignsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "A Campaign with title and content"
  object :campaign do
    field(:id, :id)
    field(:title, :string)
    field(:inserted_at, :datetime)
    field(:users, list_of(:user), resolve: dataloader(Riso.Campaigns))
  end
end
