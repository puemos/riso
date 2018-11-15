defmodule RisoWeb.Schema.Middleware.Authorize do
  @behaviour Absinthe.Middleware

  alias Riso.Accounts.User

  def call(resolution, _config) do
    case resolution.context do
      %{current_user: %User{}} ->
        resolution

      _ ->
        message = "You must login or register to continue."
        resolution |> Absinthe.Resolution.put_result({:error, message})
    end
  end
end
