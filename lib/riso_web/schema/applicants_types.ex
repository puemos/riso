defmodule RisoWeb.Schema.ApplicantsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "An applicant"
  object :applicant do
    field(:id, :id)
    field(:name, :string)
    field(:inserted_at, :datetime)
    field(:stage, :position_stage, resolve: dataloader(Riso.Positions))
    field(:reviews, list_of(:review), resolve: dataloader(Riso.Applicants))
  end

  @desc "A review of applicant for a position kpi"
  object :review do
    field(:id, :id)
    field(:score, :integer)
    field(:inserted_at, :datetime)
    field(:position, :position, resolve: dataloader(Riso.Positions))
    field(:kpi, :kpi, resolve: dataloader(Riso.Kpis))
    field(:applicant, :applicant, resolve: dataloader(Riso.Applicants))
  end
end
