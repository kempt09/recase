defmodule RecaseEnumerableTest do
  use ExUnit.Case

  describe "convert_keys/2" do
    test "should convert keys of a map" do
      assert Recase.Enumerable.convert_keys(
               %{"upper case" => "value", "upper-case2" => "value"},
               &Recase.to_pascal/1
             ) == %{"UpperCase" => "value", "UpperCase2" => "value"}
    end

    test "should convert keys of a nested map" do
      assert Recase.Enumerable.convert_keys(
               %{"upper case" => %{"upper-case2" => "value"}},
               &Recase.to_path(&1, "\\")
             ) == %{"upper\\case" => %{"upper\\case2" => "value"}}
    end

    test "should convert keys of a map in list" do
      assert Recase.Enumerable.convert_keys(
               [%{"upper case" => "value", "upper-case2" => "value"}],
               &Recase.to_pascal/1
             ) == [%{"UpperCase" => "value", "UpperCase2" => "value"}]
    end

    test "should convert keys of a nested map in list" do
      assert Recase.Enumerable.convert_keys(
               [%{"upper case" => %{"upper-case2" => "value"}}],
               &Recase.to_pascal/1
             ) == [%{"UpperCase" => %{"UpperCase2" => "value"}}]
    end

    test "should return the same list when list items are usual text" do
      assert Recase.Enumerable.convert_keys(
               ["upper case", "upper-case2"],
               &Recase.to_pascal/1
             ) == ["upper case", "upper-case2"]
    end

    test "should convert when value is a datetime" do
      datetime = %DateTime{
        year: 2000,
        month: 2,
        day: 29,
        zone_abbr: "AMT",
        hour: 23,
        minute: 0,
        second: 7,
        utc_offset: -14_400,
        std_offset: 0,
        time_zone: "America/Manaus"
      }

      assert Recase.Enumerable.convert_keys(
               %{"upper case" => datetime},
               &Recase.to_pascal/1
             ) == %{"UpperCase" => datetime}
    end

    test "should return value if no callback given" do
      assert Recase.Enumerable.convert_keys(%{
               "upper case" => %{"upper-case2" => "value"}
             }) == %{"upper case" => %{"upper-case2" => "value"}}
    end
  end

  describe "atomize_keys/2" do
    test "should convert keys of a map" do
      assert Recase.Enumerable.atomize_keys(
               %{"upper case" => "value", "upper-case2" => "value"},
               &Recase.to_pascal/1
             ) == %{UpperCase: "value", UpperCase2: "value"}
    end

    test "should convert keys of a nested map" do
      assert Recase.Enumerable.atomize_keys(
               %{"upper case" => %{"upper-case2" => "value"}},
               &Recase.to_pascal/1
             ) == %{:UpperCase => %{:UpperCase2 => "value"}}
    end

    test "should convert keys of a map in list" do
      assert Recase.Enumerable.atomize_keys(
               [%{"upper case" => "value", "upper-case2" => "value"}],
               &Recase.to_pascal/1
             ) == [%{UpperCase: "value", UpperCase2: "value"}]
    end

    test "should convert keys of a nested map in list" do
      assert Recase.Enumerable.atomize_keys(
               [%{"upper case" => %{"upper-case2" => "value"}}],
               &Recase.to_pascal/1
             ) == [%{UpperCase: %{UpperCase2: "value"}}]
    end

    test "should return the same list when list items are usual text" do
      assert Recase.Enumerable.atomize_keys(
               ["upper case", "upper-case2"],
               &Recase.to_pascal/1
             ) == ["upper case", "upper-case2"]
    end

    test "should work with mixed key formats (atom, string)" do
      assert Recase.Enumerable.atomize_keys(
               %{:atom_key => "value", "string_key" => "value"},
               &Recase.to_pascal/1
             ) == %{AtomKey: "value", StringKey: "value"}
    end

    test "should atomize without formatting if no callback given" do
      assert Recase.Enumerable.atomize_keys(%{
               :atom_key => "value",
               "string_key" => "value"
             }) == %{atom_key: "value", string_key: "value"}
    end
  end

  describe "stringify_keys/2" do
    test "should convert keys of a map" do
      assert Recase.Enumerable.stringify_keys(
               %{upperCase: "value", upper_case2: "value"},
               &Recase.to_pascal/1
             ) == %{"UpperCase" => "value", "UpperCase2" => "value"}
    end

    test "should convert keys of a nested map" do
      assert Recase.Enumerable.stringify_keys(
               %{upperCase: %{upper_case2: "value"}},
               &Recase.to_pascal/1
             ) == %{"UpperCase" => %{"UpperCase2" => "value"}}
    end

    test "should convert keys of a map in list" do
      assert Recase.Enumerable.stringify_keys(
               [%{upperCase: "value", upper_case2: "value"}],
               &Recase.to_pascal/1
             ) == [%{"UpperCase" => "value", "UpperCase2" => "value"}]
    end

    test "should convert keys of a nested map in list" do
      assert Recase.Enumerable.stringify_keys(
               [%{upperCase: %{upper_case2: "value"}}],
               &Recase.to_pascal/1
             ) == [%{"UpperCase" => %{"UpperCase2" => "value"}}]
    end

    test "should return the same list when list items are atoms" do
      assert Recase.Enumerable.stringify_keys(
               [:upperCase, :upper_case2],
               &Recase.to_pascal/1
             ) == [:upperCase, :upper_case2]
    end

    test "should work with mixed key formats (atom, string)" do
      assert Recase.Enumerable.stringify_keys(
               %{:atom_key => "value", "string_key" => "value"},
               &Recase.to_pascal/1
             ) == %{"AtomKey" => "value", "StringKey" => "value"}
    end

    test "should stringify without formatting if no callback given" do
      assert Recase.Enumerable.stringify_keys(%{
               :atom_key => "value",
               "string_key" => "value"
             }) == %{"atom_key" => "value", "string_key" => "value"}
    end
  end
end
