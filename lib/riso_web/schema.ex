defmodule RisoWeb.Schema do
  use Absinthe.Schema

  import Kronky.Payload
  alias RisoWeb.Schema.Middleware.TranslateMessages

  import_types(Absinthe.Type.Custom)
  import_types(Kronky.ValidationMessageTypes)
  import_types(RisoWeb.Schema.OptionTypes)
  import_types(RisoWeb.Schema.PositionsTypes)
  import_types(RisoWeb.Schema.AccountsTypes)
  import_types(RisoWeb.Schema.ApplicantsTypes)
  import_types(RisoWeb.Queries.AccountsQueries)
  import_types(RisoWeb.Queries.PositionsQueries)
  import_types(RisoWeb.Mutations.AuthMutations)
  import_types(RisoWeb.Mutations.AccountsMutations)
  import_types(RisoWeb.Mutations.PositionsMutations)
  import_types(RisoWeb.Mutations.ApplicantsMutations)
  import_types(Absinthe.Plug.Types)

  payload_object(:boolean_payload, :boolean)
  payload_object(:session_payload, :session)
  payload_object(:user_payload, :user)
  payload_object(:position_stage_payload, :position_stage)
  payload_object(:position_kpi_payload, :position_kpi)
  payload_object(:position_payload, :position)
  payload_object(:applicant_payload, :applicant)

  query do
    import_fields(:accounts_queries)
    import_fields(:positions_queries)
  end

  mutation do
    import_fields(:auth_mutations)
    import_fields(:accounts_mutations)
    import_fields(:positions_mutations)
    import_fields(:applicants_mutations)
  end

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: :mutation}) do
    middleware ++ [&build_payload/2, TranslateMessages]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def dataloader() do
    Dataloader.new()
    |> Dataloader.add_source(Riso.Positions, Riso.Positions.data())
    |> Dataloader.add_source(Riso.Applicants, Riso.Applicants.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end
end
