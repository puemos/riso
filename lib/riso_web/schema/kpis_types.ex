defmodule RisoWeb.Schema.KpisTypes do
  use Absinthe.Schema.Notation

  @desc "A kpi"
  object :kpi do
    field(:id, :id)
    field(:title, :string)
    field(:inserted_at, :datetime)
  end
end
