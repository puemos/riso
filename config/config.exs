# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :riso,
  ecto_repos: [Riso.Repo],
  confirmation_code_expire_hours: 6,
  client_host: System.get_env("CLIENT_HOST") || "localhost:3000",
  loggers: [Riso.RepoInstrumenter, Ecto.LogEntry]

# Configures the endpoint
config :riso, RisoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QvfN7ps5NsTx3Gz+TyYXH0vLB0JGNYxQZA3s5t7FunHZ9tENymuU1B70iHJpHRVK",
  render_errors: [view: RisoWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Riso.PubSub, adapter: Phoenix.PubSub.PG2],
  instrumenters: [Riso.PhoenixInstrumenter]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :riso, RisoWeb.Gettext, default_locale: "fr"

# Prometheus
config :prometheus, Riso.PhoenixInstrumenter,
  controller_call_labels: [:controller, :action],
  registry: :default,
  duration_unit: :microseconds

config :prometheus, Riso.PipelineInstrumenter,
  labels: [:status_class, :method, :host, :scheme, :request_path],
  registry: :default,
  duration_unit: :microseconds

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
