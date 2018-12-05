defmodule Riso.Kpis do
  @moduledoc """
  The Kpis context.
  """

  import Ecto.Query, warn: false
  alias Riso.Repo
  alias Riso.Kpis.Kpi

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end

  def list_kpis do
    Repo.all(Kpi)
  end

  def get_kpi(id), do: Repo.get(Kpi, id)

  def create_kpi(attrs \\ %{}) do
    %Kpi{}
    |> Kpi.changeset(attrs)
    |> Repo.insert()
  end

  def update_kpi(%Kpi{} = kpi, attrs) do
    kpi
    |> Kpi.changeset(attrs)
    |> Repo.update()
  end

  def delete_kpi(%Kpi{} = kpi) do
    Repo.delete(kpi)
  end

  def change_kpi(%Kpi{} = kpi) do
    Kpi.changeset(kpi, %{})
  end
end
