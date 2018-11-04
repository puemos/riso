defmodule Riso.Confirmations do
  use Timex
  import Ecto.Query, warn: false
  import Ecto.Changeset
  import Riso.Helpers.DateHelpers
  alias Riso.Repo
  alias Riso.Accounts.User

  @code_format ~r/^[0-9]{6}$/
  @msg_code_format "Le code doit être composé de 6 chiffres."

  @doc """
  Generate confirmation code
  """
  @spec generate_confirmation_code(User.t()) :: {:ok, String.t(), User.t()} | {:error, any()}
  def generate_confirmation_code(%User{} = user) do
    with {:ok, code} <- generate_code(),
         {:ok, user} <- save_code(user, %{confirmation_code: code, confirmation_sent_at: Timex.now()}) do
      {:ok, code, user}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Confirm account
  """
  @spec confirm_account(User.t(), String.t()) :: {:ok, User.t()} | {:error, any()}
  def confirm_account(%User{} = user, code) do
    attr = %{inputed_code: code, confirmed_at: Timex.now(), confirmation_code: nil, confirmation_sent_at: nil}

    user
    |> cast(attr, [:inputed_code, :confirmed_at, :confirmation_code, :confirmation_sent_at])
    |> validate_required([:inputed_code])
    |> validate_format(:inputed_code, @code_format, message: @msg_code_format)
    |> validate_already_confirmed([:inputed_code])
    |> validate_code([:inputed_code])
    |> validate_expiration([:inputed_code])
    |> Repo.update()
  end

  @doc """
  Account is confirmed ?
  """
  @spec confirmed?(User.t()) :: boolean() | {:error, String.t(), User.t()}
  def confirmed?(%User{confirmed_at: nil} = user) do
    {:ok, _code, user_with_code} = generate_confirmation_code(user)
    {:error, :no_yet_confirmed, user_with_code}
  end

  def confirmed?(%User{}), do: true

  @spec save_code(User.t(), map()) :: {:ok, User.t()} | {:error, any()}
  defp save_code(%User{} = user, attr) do
    user
    |> cast(attr, [:confirmation_code, :confirmation_sent_at])
    |> validate_required([:confirmation_code, :confirmation_sent_at])
    |> validate_format(:confirmation_code, @code_format, message: @msg_code_format)
    |> validate_already_confirmed([:inputed_code])
    |> Repo.update()
  end

  @spec generate_code(integer()) :: {:ok, String.t()}
  defp generate_code(length \\ 6) do
    code =
      10
      |> :math.pow(length)
      |> round()
      |> :rand.uniform()
      |> Integer.to_string()
      |> String.pad_leading(length, "0")

    {:ok, code}
  end

  defp validate_code(changeset, _field) do
    if changeset.valid? && changeset.data.confirmation_code != changeset.changes.inputed_code do
      add_error(changeset, :wrong_code, "Ce code est invalide. Essayez avec un autre code.")
    else
      changeset
    end
  end

  defp validate_expiration(changeset, _field) do
    confirmation_code_expire_hours = Application.fetch_env!(:riso, :confirmation_code_expire_hours)

    if changeset.valid? && expired?(changeset.data.confirmation_sent_at, hours: confirmation_code_expire_hours) do
      add_error(changeset, :expired_code, "Ce code est expiré. Veuillez en redemander un nouveau.")
    else
      changeset
    end
  end

  defp validate_already_confirmed(changeset, _field) do
    if changeset.valid? && changeset.data.confirmed_at do
      add_error(changeset, :already_confirmed, "Ce compte a déjà été validé.")
    else
      changeset
    end
  end
end
