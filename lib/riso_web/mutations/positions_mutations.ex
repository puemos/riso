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
        with {:ok, position} <- Positions.create_position(params),
             Positions.add_member(position, context[:current_user], "editor") do
          {:ok, position}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}
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
          |> Repo.get!(args[:id])

        with true <- Positions.can_edit?(context[:current_user], position),
             {:ok, position_updated} <- Positions.update_position(position, params) do
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
          |> Repo.get!(args[:id])

        with true <- Positions.can_edit?(context[:current_user], position),
             Positions.delete_position(position) do
          {:ok, position}
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

    @desc "Add a stage to a position"
    field :create_position_stage, :position_stage_payload do
      arg(:title, :string)
      arg(:position_id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        position =
          Position
          |> Repo.get!(args[:position_id])

        position_stage_args = %{position_id: position.id, title: args[:title]}

        with true <- Positions.can_edit?(context[:current_user], position),
             {:ok, position_stage} <- Positions.create_position_stage(position_stage_args) do
          {:ok, position_stage}
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

    @desc "Add a kpi to a position"
    field :create_position_kpi, :position_kpi_payload do
      arg(:title, :string)
      arg(:position_id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        position =
          Position
          |> Repo.get!(args[:position_id])

        position_kpi_args = %{position_id: position.id, title: args[:title]}

        with true <- Positions.can_edit?(context[:current_user], position),
             {:ok, position_kpi} <- Positions.create_position_kpi(position_kpi_args) do
          {:ok, position_kpi}
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
  end
end
