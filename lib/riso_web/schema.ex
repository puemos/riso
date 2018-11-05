defmodule RisoWeb.Schema do
  use Absinthe.Schema

  import Kronky.Payload
  alias RisoWeb.Schema.Middleware.TranslateMessages

  import_types(Absinthe.Type.Custom)
  import_types(Kronky.ValidationMessageTypes)
  import_types(RisoWeb.Schema.OptionTypes)
  import_types(RisoWeb.Schema.CampaignsTypes)
  import_types(RisoWeb.Schema.AccountsTypes)
  import_types(RisoWeb.Queries.AccountsQueries)
  import_types(RisoWeb.Queries.CampaignsQueries)
  import_types(RisoWeb.Mutations.AuthMutations)
  import_types(RisoWeb.Mutations.AccountsMutations)
  import_types(Absinthe.Plug.Types)

  payload_object(:boolean_payload, :boolean)
  payload_object(:session_payload, :session)
  payload_object(:user_payload, :user)

  query do
    import_fields(:accounts_queries)
    import_fields(:campaigns_queries)
  end

  mutation do
    import_fields(:auth_mutations)
    import_fields(:accounts_mutations)
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
    |> Dataloader.add_source(Riso.Campaigns, Riso.Campaigns.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end
end
