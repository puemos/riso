defmodule RisoWeb.Schema.PositionsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "A position with title and content"
  object :position do
    field(:id, :id)
    field(:title, :string)
    field(:inserted_at, :datetime)
    field(:members, list_of(:member), resolve: dataloader(Riso.Positions))
    field(:stages, list_of(:stage), resolve: dataloader(Riso.Positions))
  end

  @desc "A memebr of a position"
  object :member do
    field(:id, :id)
    field(:user, :user, resolve: dataloader(Riso.Positions))
    field(:role, :string)
    field(:inserted_at, :datetime)
  end

  @desc "A stage of a position"
  object :stage do
    field(:id, :id)
    field(:title, :string)
    field(:inserted_at, :datetime)
    field(:position, :position, resolve: dataloader(Riso.Positions))
  end
end
