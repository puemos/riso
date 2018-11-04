defmodule RisoWeb.Router do
  use RisoWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(RisoWeb.Plugs.Context)
  end

  scope "/" do
    pipe_through(:api)

    get("/", RisoWeb.HealthController, :healthz)
    get("/healthz", RisoWeb.HealthController, :healthz)
    forward("/graphql", Absinthe.Plug, schema: RisoWeb.Schema)

    if Mix.env() == :dev do
      forward("/graphiql", Absinthe.Plug.GraphiQL, schema: RisoWeb.Schema, socket: RisoWeb.UserSocket)
      forward("/emails", Bamboo.SentEmailViewerPlug)
    end
  end
end
