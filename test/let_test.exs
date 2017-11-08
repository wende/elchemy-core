defmodule Elchemy.LetTest do
  use ExUnit.Case
  import Elchemy.Let


  defmodule Test do
    use Elchemy

    def test do
      name = :hi
      let :name, fn ->
        1
      end
      test_name_0()
    end
  end

  test "Can define let" do
    assert Test.test == 1
  end

  test "Can define multiple lets" do
    assert Test.test == 1
  end

end
