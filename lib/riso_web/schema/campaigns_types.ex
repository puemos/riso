defmodule RisoWeb.Schema.CampaignsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  alias RisoWeb.Helpers.StringHelpers
  alias Riso.Campaigns
  alias Riso.Campaigns.Campaign

  @desc "A Campaign with title and content"
  object :Campaign do
    field(:id, :id)
    field(:title, :string)
    field(:inserted_at, :datetime)
    field(:author, :author, resolve: dataloader(Campaigns))
    field(:comments, list_of(:comment), resolve: dataloader(Campaigns))
  end

  @desc "user"
  object :user do
    field(:id, :id)
    field(:name, :string)
  end
end
