defmodule RisoWeb.Schema.CampaignsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "A campaign with title and content"
  object :campaign do
    field(:id, :id)
    field(:title, :string)
    field(:inserted_at, :datetime)
    field(:author, :user)
    field(:users, list_of(:user), resolve: dataloader(Riso.Campaigns))
    field(:stages, list_of(:stage), resolve: dataloader(Riso.Campaigns))
  end

  @desc "A stage of a campaign"
  object :stage do
    field(:id, :id)
    field(:title, :string)
    field(:inserted_at, :datetime)
    field(:campaign, :campaign, resolve: dataloader(Riso.Campaigns))
  end
end
