defmodule RisoWeb.Mutations.PositionsMutations do
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import RisoWeb.Helpers.ValidationMessageHelpers

  alias RisoWeb.Schema.Middleware
  alias Riso.Repo
  alias Riso.Positions
  alias Riso.Positions.Position

  input_object :position_input do
    field(:title, :string)
  end

  object :positions_mutations do
    @desc "Create a position"
    field :create_position, :position_payload do
      arg(:input, :position_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params}, %{context: context} ->
        case context[:current_user] |> Positions.create(params) do
          {:ok, position} -> {:ok, position}
          {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
        end
      end)
    end

    @desc "Update a Position and return Position"
    field :update_position, :position_payload do
      arg(:id, non_null(:id))
      arg(:input, :position_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params} = args, %{context: context} ->
        position =
          Position
          |> preload(:members)
          |> Repo.get!(args[:id])

        with true <- Positions.can(:edit, context[:current_user], position),
             {:ok, position_updated} <- Positions.update(position, params) do
          {:ok, position_updated}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "no you can not"}
        end
      end)
    end

    @desc "Destroy a Position"
    field :delete_position, :position_payload do
      arg(:id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        position =
          Position
          |> preload(:members)
          |> Repo.get!(args[:id])

        case Positions.can(:edit, context[:current_user], position) do
          true ->
            position |> Positions.delete()

          false ->
            {:error, "no you can not"}

          {:error, msg} ->
            {:ok, generic_message(msg)}
        end
      end)
    end

    @desc "Create a stage to position"
    field :create_stage, :stage_payload do
      arg(:title, :string)
      arg(:position_id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        position =
          Position
          |> preload(:members)
          |> Repo.get!(args[:position_id])

        case Positions.can(:edit, context[:current_user], position) do
          true ->
            case Positions.create_stage(position, %{title: args[:title]}) do
              {:ok, stage} -> {:ok, stage}
              {:error, %Ecto.Changeset{} = changeset} -> {:ok, changeset}
            end

          false ->
            {:error, "no you can not"}

          {:error, msg} ->
            {:ok, generic_message(msg)}
        end
      end)
    end
  end
end
