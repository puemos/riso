# import RisoWeb.FakeS3, only: [check_fakes3: 0]

# check_fakes3()

# Application.put_env(:wallaby, :base_url, "http://" <> (System.get_env("CLIENT_HOST") || "localhost:3000"))
# {:ok, _} = Application.ensure_all_started(:ex_machina)
# {:ok, _} = Application.ensure_all_started(:wallaby)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Riso.Repo, :manual)
