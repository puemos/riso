defmodule RisoWeb.Schema.PositionsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "A position with title and content"
  object :position do
    field(:id, non_null(:id))
    field(:title, non_null(:string))
    field(:inserted_at, non_null(:datetime))
    field(:organization, non_null(:organization), resolve: dataloader(Riso.Organizations))
    field(:members, non_null(list_of(:position_member)), resolve: dataloader(Riso.Positions))
    field(:stages, non_null(list_of(:position_stage)), resolve: dataloader(Riso.Positions))
    field(:kpis, non_null(list_of(:kpi)), resolve: dataloader(Riso.Kpis))
  end

  @desc "A memebr of a position"
  object :position_member do
    field(:id, non_null(:id))
    field(:user, non_null(:user), resolve: dataloader(Riso.Positions))
    field(:role, non_null(:position_memebr_role))
    field(:inserted_at, non_null(:datetime))
  end

  enum :position_memebr_role do
    description("The position member role")

    value(:editor, as: "editor", description: "Can edit and view the position")
    value(:viewer, as: "viewer", description: "Can view the position")
  end

  @desc "A stage of a position"
  object :position_stage do
    field(:id, non_null(:id))
    field(:title, non_null(:string))
    field(:inserted_at, non_null(:datetime))
    field(:applicants, non_null(list_of(:applicant)), resolve: dataloader(Riso.Applicants))
    field(:position, non_null(:position), resolve: dataloader(Riso.Positions))
  end
end
