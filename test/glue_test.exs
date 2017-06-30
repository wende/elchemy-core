defmodule Elmchemy.GlueTest do
  use ExUnit.Case

  defmodule Mock do
    require Elmchemy.Glue
    import Elmchemy.Glue

    def test(x1,x2,x3,x4), do: [x1,x2,x3,x4]
    defswap swapped_test, to: test/4
    defreverse reverse_test, to: test/4
  end

  test "Mock works" do
    assert Mock.test(1,2,3,4) == [1,2,3,4]
  end

  test "Reverse arguments" do
    assert Mock.reverse_test(1,2,3,4) == [4,3,2,1]
  end

  test "Swapped arguments" do
    assert Mock.swapped_test(1,2,3,4) == [4,1,2,3 ]
  end
end
