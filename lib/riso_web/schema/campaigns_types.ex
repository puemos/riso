defmodule RisoWeb.Schema.CampaignsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "A campaign with title and content"
  object :campaign do
    field(:id, :id)
    field(:title, :string)
    field(:inserted_at, :datetime)
    field(:members, list_of(:member), resolve: dataloader(Riso.Campaigns))
    field(:stages, list_of(:stage), resolve: dataloader(Riso.Campaigns))
  end

  @desc "A memebr of a campaign"
  object :member do
    field(:id, :id)
    field(:user, :user, resolve: dataloader(Riso.Campaigns))
    field(:role, :string)
    field(:inserted_at, :datetime)
  end

  @desc "A stage of a campaign"
  object :stage do
    field(:id, :id)
    field(:title, :string)
    field(:inserted_at, :datetime)
    field(:campaign, :campaign, resolve: dataloader(Riso.Campaigns))
  end
end
