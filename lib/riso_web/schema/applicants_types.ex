defmodule RisoWeb.Schema.ApplicantsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  @desc "An applicant"
  object :applicant do
    field(:id, :id)
    field(:name, :string)
    field(:inserted_at, :datetime)
    field(:position, :position, resolve: dataloader(Riso.Positions))
    field(:position_stage, :position_stage, resolve: dataloader(Riso.Positions))
  end
end
