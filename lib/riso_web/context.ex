defmodule RisoWeb.Plugs.Context do
  @behaviour Plug

  alias RisoWeb.Helpers.StringHelpers
  alias Riso.Accounts.User
  alias Riso.Repo
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    put_private(conn, :absinthe, %{context: context})
  end

  defp build_context(conn) do
    %{}
    |> add_remote_ip_to_context(conn)
    |> add_user_to_context(conn)
  end

  defp add_remote_ip_to_context(%{} = context, conn) do
    case conn.remote_ip do
      remote_ip when is_tuple(remote_ip) -> Map.put(context, :remote_ip, get_string_ip(remote_ip))
      _ -> context
    end
  end

  defp add_user_to_context(%{} = context, conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         true <- StringHelpers.present?(token),
         {:ok, user} <- get_user(token) do
      Map.put(context, :current_user, user)
    else
      _ -> context
    end
  end

  @spec get_user(String.t()) :: {:ok, User}
  defp get_user(token) do
    user = User |> Repo.get_by(access_token: token)
    {:ok, user}
  end

  defp get_string_ip(address) when is_tuple(address) do
    address
    |> :inet_parse.ntoa()
    |> IO.iodata_to_binary()
  end
end
