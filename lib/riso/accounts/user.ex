defmodule Riso.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Riso.Accounts.User
  alias Riso.Positions.{Position, PositionMember}
  alias Riso.Organizations.{Organization, OrganizationMember}

  schema "users" do
    field :email, :string
    field :name, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :access_token, :string

    field :current_sign_in_at, :naive_datetime
    field :last_sign_in_at, :naive_datetime
    field :sign_in_count, :integer, default: 0
    field :current_sign_in_ip, :string
    field :last_sign_in_ip, :string

    field :confirmation_code, :string
    field :inputed_code, :string, virtual: true
    field :confirmed_at, :naive_datetime
    field :confirmation_sent_at, :naive_datetime

    many_to_many :positions, Position, join_through: PositionMember
    many_to_many :organizations, Organization, join_through: OrganizationMember

    timestamps(type: :utc_datetime)
  end

  def changeset(%User{} = user, attrs \\ %{}) do
    attrs = attrs |> Map.delete(:password)

    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def changeset(%User{} = user, attrs, :tracked_fields) do
    user
    |> cast(attrs, [
      :current_sign_in_at,
      :last_sign_in_at,
      :current_sign_in_ip,
      :last_sign_in_ip,
      :sign_in_count
    ])
  end

  def changeset(%User{} = user, attrs, :password) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_required([:name, :email, :password, :password_confirmation])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, message: "Ne correspond pas")
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  @spec put_pass_hash(Ecto.Changeset.t()) :: Ecto.Changeset.t() | no_return
  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
