defmodule Elchemy.GlueTest do
  use ExUnit.Case

  defmodule Mock do
    require Elchemy.Glue
    import Elchemy.Glue

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

  test "Can define recursive function" do
    import Elchemy.Glue

    fun = rec fun, fn
      0 -> 0
      a -> a + fun.(a - 1)
    end

    assert fun.(3) == 6
  end
end
