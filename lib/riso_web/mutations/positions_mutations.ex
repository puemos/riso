defmodule RisoWeb.Mutations.PositionsMutations do
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import RisoWeb.Helpers.ValidationMessageHelpers

  alias RisoWeb.Schema.Middleware
  alias Riso.Positions

  input_object :position_input do
    field(:title, :string)
  end

  input_object :position_stage_input do
    field(:title, :string)
  end

  input_object :position_kpi_input do
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
        with position when not is_nil(position) <- Positions.get_position(args[:id]),
             true <- Positions.can_edit?(position, context[:current_user]),
             {:ok, position_updated} <- Positions.update_position(position, params) do
          {:ok, position_updated}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "Unauthorize"}

          nil ->
            {:error, "Not found"}
        end
      end)
    end

    @desc "Destroy a Position"
    field :delete_position, :position_payload do
      arg(:id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        with position when not is_nil(position) <- Positions.get_position(args[:id]),
             true <- Positions.can_edit?(position, context[:current_user]),
             Positions.delete_position(position) do
          {:ok, position}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "Unauthorize"}

          nil ->
            {:error, "Not found"}
        end
      end)
    end

    @desc "Add a stage to a position"
    field :create_position_stage, :position_stage_payload do
      arg(:input, :position_stage_input)
      arg(:position_id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        position_stage_args =
          %{position_id: args[:position_id]}
          |> Enum.into(args[:input])

        with position when not is_nil(position) <- Positions.get_position(args[:id]),
             true <- Positions.can_edit?(position, context[:current_user]),
             {:ok, position_stage} <- Positions.create_position_stage(position_stage_args) do
          {:ok, position_stage}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "Unauthorize"}

          nil ->
            {:error, "Not found"}
        end
      end)
    end

    @desc "Update a position stage"
    field :update_position_stage, :position_stage_payload do
      arg(:id, non_null(:id))
      arg(:input, :position_stage_input)
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        position_stage_args = args[:input]

        with position_stage when not is_nil(position_stage) <-
               Positions.get_position_stage(args[:id]),
             true <- Positions.can_edit_resource?(position_stage, context[:current_user]),
             {:ok, position_stage} <-
               Positions.update_position_stage(position_stage, position_stage_args) do
          {:ok, position_stage}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "Unauthorize"}

          nil ->
            {:error, "Not found"}
        end
      end)
    end

    @desc "Destroy a position stage"
    field :delete_position_stage, :position_stage_payload do
      arg(:id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        with position_stage when not is_nil(position_stage) <-
               Positions.get_position_stage(args[:id]),
             true <- Positions.can_edit_resource?(position_stage, context[:current_user]),
             {:ok, position_stage} <- Positions.delete_position_stage(position_stage) do
          {:ok, position_stage}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "Unauthorize"}

          nil ->
            {:error, "Not found"}
        end
      end)
    end

    @desc "Add a kpi to a position"
    field :create_position_kpi, :position_kpi_payload do
      arg(:input, :position_kpi_input)
      arg(:position_id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        position_kpi_args =
          %{position_id: args[:position_id]}
          |> Enum.into(args[:input])

        with position when not is_nil(position) <- Positions.get_position(args[:position_id]),
             true <- Positions.can_edit?(position, context[:current_user]),
             {:ok, position_kpi} <- Positions.create_position_kpi(position_kpi_args) do
          {:ok, position_kpi}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "Unauthorize"}

          nil ->
            {:error, "Not found"}
        end
      end)
    end

    @desc "Update a position kpi"
    field :update_position_kpi, :position_kpi_payload do
      arg(:id, non_null(:id))
      arg(:input, :position_kpi_input)
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        position_kpi_args = args[:input]

        with position_kpi when not is_nil(position_kpi) <- Positions.get_position_kpi(args[:id]),
             true <- Positions.can_edit_resource?(position_kpi, context[:current_user]),
             {:ok, position_kpi} <- Positions.update_position_kpi(position_kpi, position_kpi_args) do
          {:ok, position_kpi}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "Unauthorize"}

          nil ->
            {:error, "Not found"}
        end
      end)
    end

    @desc "Destroy a position kpi"
    field :delete_position_kpi, :position_kpi_payload do
      arg(:id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        with position_kpi when not is_nil(position_kpi) <- Positions.get_position_kpi(args[:id]),
             true <- Positions.can_edit_resource?(position_kpi, context[:current_user]),
             {:ok, position_kpi} <- Positions.delete_position_kpi(position_kpi) do
          {:ok, position_kpi}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "Unauthorize"}

          nil ->
            {:error, "Not found"}
        end
      end)
    end
  end
end
