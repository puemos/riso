defmodule RisoWeb.Schema.ApplicantsTypes do
  use Absinthe.Schema.Notation

  @desc "An applicant"
  object :applicant do
    field(:id, :id)
    field(:name, :string)
    field(:inserted_at, :datetime)
  end
end
