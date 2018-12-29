defmodule RisoWeb.Schema.KpisTypes do
  use Absinthe.Schema.Notation

  @desc "A kpi"
  object :kpi do
    field(:id, non_null(:id))
    field(:title, non_null(:string))
    field(:inserted_at, non_null(:datetime))
  end
end
