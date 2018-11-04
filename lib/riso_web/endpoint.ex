defmodule RisoWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :riso
  use Absinthe.Phoenix.Endpoint

  socket("/socket", RisoWeb.UserSocket)

  plug(Riso.PipelineInstrumenter)
  plug(Riso.PrometheusExporter)

  if Application.get_env(:riso, :sql_sandbox) do
    plug(Phoenix.Ecto.SQL.Sandbox)
  end

  if Mix.env() == :dev do
    plug(Plug.Static, at: "/uploads", from: Path.expand('./uploads'), gzip: false)
  end

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["*/*"],
    json_decoder: Poison
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  if Mix.env() == :dev || Mix.env() == :test do
    plug(CORSPlug, origin: "http://" <> Application.fetch_env!(:riso, :client_host))
  end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  # plug Plug.Session,
  #   store: :cookie,
  #   key: "_riso_key",
  #   signing_salt: "63bcqiEc"

  plug(RisoWeb.Router)

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
