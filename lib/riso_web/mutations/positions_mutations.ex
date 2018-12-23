defmodule RisoWeb.Mutations.PositionsMutations do
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import RisoWeb.Helpers.ValidationMessageHelpers

  alias RisoWeb.Schema.Middleware
  alias Riso.Positions
  alias Riso.Kpis
  alias Riso.Repo

  input_object :position_input do
    field(:title, :string)
    field(:organization_id, :id)
  end

  input_object :position_stage_input do
    field(:title, :string)
  end

  input_object :position_member_input do
    field(:role, :position_memebr_role)
  end

  object :positions_mutations do
    @desc "Create a position"
    field :create_position, :position_payload do
      arg(:input, :position_input)
      middleware(Middleware.Authorize)

      resolve(fn %{input: params}, %{context: context} ->
        current_user = context[:current_user]

        with {:ok, organization} <- Riso.Organizations.get_organization(params[:organization_id]),
             true <- Riso.Organizations.is_member?(organization, current_user),
             params_with_organization <- Map.merge(params, %{organization_id: organization.id}),
             {:ok, position} <- Positions.create_position(params_with_organization),
             Positions.add_member(position, current_user, "editor") do
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
    field :add_position_stage, :position_stage_payload do
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
    field :add_position_kpi, :position_payload do
      arg(:position_id, non_null(:id))
      arg(:kpi_id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        with kpi when not is_nil(kpi) <- Kpis.get_kpi(args[:kpi_id]),
             position when not is_nil(position) <- Positions.get_position(args[:position_id]),
             true <- Positions.can_edit?(position, context[:current_user]),
             {:ok, _position_kpi} <- Positions.add_kpi(position, kpi) do
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

    @desc "Remove a kpi from a position"
    field :remove_position_kpi, :position_payload do
      arg(:position_id, non_null(:id))
      arg(:kpi_id, non_null(:id))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        with kpi when not is_nil(kpi) <- Kpis.get_kpi(args[:kpi_id]),
             position when not is_nil(position) <- Positions.get_position(args[:position_id]),
             true <- Positions.can_edit?(position, context[:current_user]),
             {1, nil} <- Positions.remove_kpi(position, kpi) do
          {:ok, position}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, msg} ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "Unauthorize"}

          {0, _} ->
            {:error, "Not found"}

          nil ->
            {:error, "Not found"}
        end
      end)
    end

    @desc "Add a member to a position"
    field :add_position_member, :position_member_payload do
      arg(:input, :position_member_input)
      arg(:position_id, non_null(:id))
      arg(:member_email, non_null(:string))
      middleware(Middleware.Authorize)

      resolve(fn args, %{context: context} ->
        position_member_args = args[:input]

        with position when not is_nil(position) <-
               Positions.get_position(args[:position_id]) |> Repo.preload(:organization),
             {:ok, user} when not is_nil(user) <-
               Riso.Accounts.user_by_email(args[:member_email]),
             true <- Riso.Organizations.is_member?(position.organization, user),
             true <- Positions.can_edit?(position, context[:current_user]),
             {:ok, position_member} <-
               Positions.add_member(position, user, position_member_args[:role]) do
          {:ok, position_member}
        else
          {:error, %Ecto.Changeset{} = changeset} ->
            {:ok, changeset}

          {:error, %Ecto.Query{}} ->
            {:ok, generic_message("The email #{args[:member_email]} was not found")}

          {:error, msg} when is_binary(msg) ->
            {:ok, generic_message(msg)}

          false ->
            {:error, "Unauthorize"}

          nil ->
            {:error, "Not found"}

          _ ->
            {:ok, generic_message("Ops, error")}
        end
      end)
    end
  end
end
