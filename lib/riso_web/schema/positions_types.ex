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
    field(:kpis, list_of(:kpi), resolve: dataloader(Riso.Kpis))
  end

  @desc "A memebr of a position"
  object :position_member do
    field(:id, :id)
    field(:user, :user, resolve: dataloader(Riso.Positions))
    field(:role, :position_memebr_role)
    field(:inserted_at, :datetime)
  end

  enum :position_memebr_role do
    description("The position member role")

    value(:editor, as: "editor", description: "Can edit and view the position")
    value(:viewer, as: "viewer", description: "Can view the position")
  end

  @desc "A stage of a position"
  object :position_stage do
    field(:id, :id)
    field(:title, :string)
    field(:inserted_at, :datetime)
    field(:applicants, list_of(:applicant), resolve: dataloader(Riso.Applicants))
    field(:position, :position, resolve: dataloader(Riso.Positions))
  end
end
