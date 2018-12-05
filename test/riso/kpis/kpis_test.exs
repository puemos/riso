defmodule Riso.KpisTest do
  use Riso.DataCase

  alias Riso.Kpis

  describe "kpis" do
    alias Riso.Kpis.Kpi

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def kpi_fixture(attrs \\ %{}) do
      {:ok, kpi} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Kpis.create_kpi()

      kpi
    end

    test "list_kpis/0 returns all kpis" do
      kpi = kpi_fixture()
      assert Kpis.list_kpis() == [kpi]
    end

    test "get_kpi!/1 returns the kpi with given id" do
      kpi = kpi_fixture()
      assert Kpis.get_kpi!(kpi.id) == kpi
    end

    test "create_kpi/1 with valid data creates a kpi" do
      assert {:ok, %Kpi{} = kpi} = Kpis.create_kpi(@valid_attrs)
      assert kpi.title == "some title"
    end

    test "create_kpi/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Kpis.create_kpi(@invalid_attrs)
    end

    test "update_kpi/2 with valid data updates the kpi" do
      kpi = kpi_fixture()
      assert {:ok, %Kpi{} = kpi} = Kpis.update_kpi(kpi, @update_attrs)
      assert kpi.title == "some updated title"
    end

    test "update_kpi/2 with invalid data returns error changeset" do
      kpi = kpi_fixture()
      assert {:error, %Ecto.Changeset{}} = Kpis.update_kpi(kpi, @invalid_attrs)
      assert kpi == Kpis.get_kpi!(kpi.id)
    end

    test "delete_kpi/1 deletes the kpi" do
      kpi = kpi_fixture()
      assert {:ok, %Kpi{}} = Kpis.delete_kpi(kpi)
      assert_raise Ecto.NoResultsError, fn -> Kpis.get_kpi!(kpi.id) end
    end

    test "change_kpi/1 returns a kpi changeset" do
      kpi = kpi_fixture()
      assert %Ecto.Changeset{} = Kpis.change_kpi(kpi)
    end
  end
end
