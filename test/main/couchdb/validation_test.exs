defmodule Main.CouchDB.ValidationTest do
  use ExUnit.Case

  alias Main.CouchDB.Validation

  # test "selector?" do
  #     input = %{
  #         "name" => "Paul",
  #         "location" => "Boston"
  #     }
  #     assert Validation.selector?(input)
  # end

  describe "modulo?" do
    test "valid positive" do
      assert Validation.modulo?([12, 5])
    end

    test "valid negative" do
      assert Validation.modulo?([-12, -5])
    end

    test "invalid mixed" do
      refute Validation.modulo?([-12, 5])
    end

    test "invalid other tuple" do
      refute Validation.modulo?(["a", 5])
    end

    test "invalid other any" do
      refute Validation.modulo?("any")
    end
  end

  describe "selector?" do
    for {name, input} <- [
          {"simple",
           %{
             "name" => "Paul",
             "location" => "Boston"
           }},
          {"sub",
           %{
             "imdb" => %{
               "rating" => 8
             }
           }},
          {"$eq",
           %{
             "director" => %{
               "$eq" => "Lars von Trier"
             }
           }},
          {"$and",
           %{
             "$and" => [
               %{
                 "director" => %{
                   "$eq" => "Lars von Trier"
                 }
               },
               %{
                 "year" => %{
                   "$size" => 2003
                 }
               }
             ]
           }}
        ] do
      @name name
      @input input
      test "valid #{@name}" do
        assert Validation.selector?(@input)
      end
    end

    for {name, input} <- [
          {"simple",
           %{
             1 => "test"
           }},
          {"sub",
           %{
             "imdb" => %{
               6 => 8
             }
           }},
          {"$and",
           %{
             "$and" => [
               %{
                 "director" => %{
                   "$eq" => "Lars von Trier"
                 }
               },
               %{
                 "year" => %{
                   "$size" => "test"
                 }
               }
             ]
           }}
        ] do
      @name name
      @input input
      test "invalid #{@name}" do
        refute Validation.selector?(@input)
      end
    end
  end

  describe "sort?" do
    test "valid fields" do
      assert Validation.sort?(["field1", "field2"])
    end

    test "valid map" do
      assert Validation.sort?([%{"field1" => "asc"}, %{"field2" => "desc"}])
    end

    test "invalid map order" do
      refute Validation.sort?([%{"field1" => "testing"}, %{"field2" => "desc"}])
    end

    test "invalid map size" do
      refute Validation.sort?([%{"field1" => "testing", "field2" => "desc"}])
    end
  end
end
