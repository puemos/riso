defmodule RisoWeb.Schema.PositionsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "A position with title and content"
  object :position do
    field(:id, :id)
    field(:title, :string)
    field(:inserted_at, :datetime)
    field(:members, list_of(:position_member), resolve: dataloader(Riso.Positions))
    field(:stages, list_of(:position_stage), resolve: dataloader(Riso.Positions))
    field(:kpis, list_of(:position_kpi), resolve: dataloader(Riso.Positions))
  end

  @desc "A memebr of a position"
  object :position_member do
    field(:id, :id)
    field(:user, :user, resolve: dataloader(Riso.Positions))
    field(:role, :string)
    field(:inserted_at, :datetime)
  end

  @desc "A stage of a position"
  object :position_stage do
    field(:id, :id)
    field(:title, :string)
    field(:inserted_at, :datetime)
    field(:applicants, list_of(:applicant), resolve: dataloader(Riso.Applicants))
    field(:position, :position, resolve: dataloader(Riso.Positions))
  end

  @desc "A kpi of a position"
  object :position_kpi do
    field(:id, :id)
    field(:title, :string)
    field(:inserted_at, :datetime)
    field(:position, :position, resolve: dataloader(Riso.Positions))
  end
end
