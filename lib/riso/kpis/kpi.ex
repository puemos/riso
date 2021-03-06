defmodule Riso.Kpis.Kpi do
  use Ecto.Schema
  import Ecto.Changeset

  schema "kpis" do
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(kpi, attrs) do
    kpi
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
