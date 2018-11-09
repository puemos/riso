defmodule RisoWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: RisoWeb.Schema

  def connect(_params, socket) do
    {:ok, assign(socket, :absinthe, %{schema: RisoWeb.Schema})}
  end

  def id(_socket), do: nil
end
