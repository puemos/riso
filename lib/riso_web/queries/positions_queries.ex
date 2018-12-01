defmodule RisoWeb.Queries.PositionsQueries do
  use Absinthe.Schema.Notation

  import Ecto.Query, warn: false

  alias RisoWeb.Schema.Middleware
  alias Riso.Repo
  alias Riso.Positions
  alias Riso.Positions.{Position}

  object :positions_queries do
    @desc "get current user positions list"
    field :positions, list_of(:position) do
      middleware(Middleware.Authorize)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, %{context: context} ->
        user = context[:current_user]

        positions =
          Positions.list_position_by_user(user)
          |> Positions.search(args[:keywords])
          |> order_by(desc: :inserted_at)
          |> Repo.paginate(args[:offset])
          |> Repo.all()

        {:ok, positions}
      end)
    end

    @desc "Number of positions for current user"
    field :positions_count, :integer do
      middleware(Middleware.Authorize)
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, %{context: context} ->
        user = context[:current_user]

        positions_count =
          Positions.list_position_by_user(user)
          |> Positions.search(args[:keywords])
          |> Repo.count()

        {:ok, positions_count}
      end)
    end

    @desc "fetch a position by id"
    field :position, :position do
      middleware(Middleware.Authorize)
      arg(:id, non_null(:id))

      resolve(fn args, %{context: context} ->
        user = context[:current_user]

        with(
          position when not is_nil(position) <- Positions.get_position(args[:id]),
          true <- Positions.can_view?(position, user)
        ) do
          {:ok, position}
        else
          nil ->
            {:error, "Not found"}

          false ->
            {:error, "Unauthorize"}
        end
      end)
    end

    @desc "Position options for a field"
    field :position_options, list_of(:option) do
      middleware(Middleware.Authorize)
      arg(:field, non_null(:string))

      resolve(fn args, _ ->
        field = String.to_existing_atom(args[:field])

        options =
          Enum.map(Position.options()[field], fn opt ->
            %{label: opt, value: opt}
          end)

        {:ok, options}
      end)
    end
  end
end
