defmodule RisoWeb.Schema.ApplicantsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "An applicant"
  object :applicant do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:photo, :string)
    field(:inserted_at, non_null(:datetime))
    field(:reviews, non_null(list_of(:review)), resolve: dataloader(Riso.Applicants))
    field(:position, :position, resolve: dataloader(Riso.Positions))
    field(:stage, :position_stage, resolve: dataloader(Riso.Positions))
  end

  @desc "A review of applicant for a position kpi"
  object :review do
    field(:id, non_null(:id))
    field(:score, non_null(:integer))
    field(:inserted_at, non_null(:datetime))
    field(:reviewer, non_null(:user), resolve: dataloader(Riso.Accounts))
    field(:position, non_null(:position), resolve: dataloader(Riso.Positions))
    field(:kpi, non_null(:kpi), resolve: dataloader(Riso.Kpis))
    field(:applicant, non_null(:applicant), resolve: dataloader(Riso.Applicants))
  end
end
