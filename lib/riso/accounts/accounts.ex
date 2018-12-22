defmodule Riso.Accounts do
  import Ecto.Query, warn: false
  alias Riso.Repo
  alias Riso.Accounts.User

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs, :password)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def change_password(%User{} = user, %{
        password: password,
        password_confirmation: password_confirmation
      }) do
    user
    |> User.changeset(
      %{password: password, password_confirmation: password_confirmation},
      :password
    )
    |> Repo.update()
  end

  def cancel_account(%User{} = user) do
    user |> Repo.delete()
  end

  @doc """
  Generate an access token and associates it with the user
  """
  @spec generate_access_token(User.t()) :: {:ok, String.t(), User.t()}
  def generate_access_token(user) do
    access_token = generate_token(user)
    user_modified = Ecto.Changeset.change(user, access_token: access_token)
    {:ok, user} = Repo.update(user_modified)
    {:ok, access_token, user}
  end

  @spec generate_token(User.t()) :: String.t()
  defp generate_token(user) do
    Base.encode64(
      :erlang.md5("#{:os.system_time(:milli_seconds)}-#{user.id}-#{SecureRandom.hex()}")
    )
  end

  @spec revoke_access_token(User.t()) :: {:ok, User.t()} | {:error, any()}
  def revoke_access_token(user) do
    user_modified = Ecto.Changeset.change(user, access_token: nil)
    {:ok, _user} = Repo.update(user_modified)
  end

  @doc """
  Authenticate user with email and password
  """
  @spec authenticate(User.t(), String.t()) :: {:ok, User.t()} | {:error, String.t()}
  def authenticate(nil, _password), do: {:error, "The email is invalid"}
  def authenticate(_email, nil), do: {:error, "The password is invalid"}

  def authenticate(email, password) do
    user = User |> Repo.get_by(email: String.downcase(email))

    case check_password(user, password) do
      true -> {:ok, user}
      _ -> {:error, "The Email or password invalid"}
    end
  end

  @spec check_password(User.t(), String.t()) :: boolean()
  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, user.password_hash)
    end
  end

  @doc """
  Update tracked fields
  """
  @spec update_tracked_fields(User.t(), String.t()) :: {:ok, User.t()} | {:error, any()}
  def update_tracked_fields(%User{} = user, remote_ip) do
    attrs = %{
      current_sign_in_at: Timex.now(),
      last_sign_in_at: user.current_sign_in_at,
      current_sign_in_ip: remote_ip,
      sign_in_count: user.sign_in_count + 1
    }

    attrs =
      case user.current_sign_in_ip != remote_ip do
        true -> Map.put(attrs, :last_sign_in_ip, user.current_sign_in_ip)
        _ -> attrs
      end

    user
    |> User.changeset(attrs, :tracked_fields)
    |> Repo.update()
  end

  @doc """
  Get user by email
  """
  @spec user_by_email(String.t()) :: {:ok, any()} | {:error, Ecto.Query}
  def user_by_email(email) do
    User
    |> Ecto.Query.where(email: ^String.downcase(email))
    |> Repo.fetch()
  end
end
