defmodule Riso.Mixfile do
  use Mix.Project

  def project do
    [
      app: :riso,
      version: "1.0.0",
      elixir: "~> 1.6.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Riso.Application, []},
      extra_applications: [:logger, :runtime_tools, :absinthe, :absinthe_plug]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Framework
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.10"},
      {:ecto_sql, "~> 3.0"},
      {:ecto, "~> 3.0"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:postgrex, "~> 0.13"},

      # Plugs
      {:cors_plug, "~> 1.5.2"},

      # GraphQL
      {:absinthe, "~> 1.4.12", override: true},
      {:absinthe_plug, "~> 1.4.4"},
      {:absinthe_phoenix, "~> 1.4.3"},
      {:dataloader, "~> 1.0.4"},
      {:kronky, "~> 0.5.0"},

      # Utils
      {:bcrypt_elixir, "~> 1.0.7"},
      {:comeonin, "~> 4.1.1"},
      {:gettext, "~> 0.15.0"},
      {:poison, "~> 3.1.0"},
      {:hackney, "~> 1.12.1", override: true},
      {:secure_random, "~> 0.5"},
      {:sweet_xml, "~> 0.6"},
      {:timex, "~> 3.1"},
      {:distillery, "~> 1.5", runtime: false},
      {:jason, "~> 1.0"},

      # Mails
      {:bamboo, "~> 1.0.0"},

      # Dev
      {:credo, "~> 0.9.3", only: :dev, runtime: false},

      # Tests
      {:wallaby, github: "keathley/wallaby", runtime: false, only: :test},
      {:ex_machina, "~> 2.2", only: :test},
      {:faker, "~> 0.10", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
