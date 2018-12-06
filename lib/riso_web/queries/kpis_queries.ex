defmodule RisoWeb.Queries.KpisQueries do
  use Absinthe.Schema.Notation

  import Ecto.Query, warn: false

  alias RisoWeb.Schema.Middleware
  alias Riso.Repo
  alias Riso.Kpis
  alias Riso.Kpis.Kpi

  object :kpis_queries do
    @desc "get kpis list"
    field :kpis, list_of(:kpi) do
      middleware(Middleware.Authorize)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, _ ->
        kpis =
          Kpi
          |> Kpis.search(args[:keywords])
          |> order_by(desc: :inserted_at)
          |> Repo.paginate(args[:offset])
          |> Repo.all()

        {:ok, kpis}
      end)
    end
  end
end
