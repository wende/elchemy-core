defmodule DebugFormatTest do
  use ExUnit.Case

  alias Elchemy.Format

  test "Formats simple types" do
    assert Format.inspect({:type, 1, 2}) == "Type 1 2"
  end

  test "Formats simple maps" do
    assert Format.inspect(%{a: 1, b: 2}) == "{ a = 1, b = 2 }"
  end

  test "Formats simple non-type (doesn't start with atom) tuples" do
    assert Format.inspect({1, 2}) == "(1, 2)"
  end

  test "Formats simple nested " do
    assert Format.inspect([{1, {2, 3}}, {:type, 1, 2}]) == "[(1, (2, 3)), Type 1 2]"
  end

  test "Extra: Puts parens on nested types" do
    assert Format.inspect({:a, 1, {:b, 2, 3}, 4}) == "A 1 (B 2 3) 4"
  end

end
