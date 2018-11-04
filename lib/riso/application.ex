defmodule Riso.Application do
  use Application

  alias Riso.{
    PhoenixInstrumenter,
    PipelineInstrumenter,
    PrometheusExporter,
    RepoInstrumenter
  }

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Prometheus
    require Prometheus.Registry
    PhoenixInstrumenter.setup()
    PipelineInstrumenter.setup()
    RepoInstrumenter.setup()

    if :os.type() == {:unix, :linux} do
      Prometheus.Registry.register_collector(:prometheus_process_collector)
    end

    PrometheusExporter.setup()

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Riso.Repo, []),
      # Start the endpoint when the application starts
      supervisor(RisoWeb.Endpoint, []),
      # Start your own worker by calling: Riso.Worker.start_link(arg1, arg2, arg3)
      # worker(Riso.Worker, [arg1, arg2, arg3]),
      supervisor(Absinthe.Subscription, [RisoWeb.Endpoint])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Riso.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RisoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
