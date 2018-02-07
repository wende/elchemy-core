defmodule Elchemy.Elixir.AstTest do
  use ExUnit.Case

  alias Elchemy.Elixir.Ast

  test "Can create simple block" do
    correct = quote do
      a(1,2,3)
    end
    args = {:application, {:atom, "a"}, [{:int, 1},{:int, 2},{:int, 3}]}
    assert Ast.to_elixir_ast(args) == correct
  end

  test "Can create comples blocks" do
    correct = quote do
      {:a, :b} == 1 + a
    end
    args = {:application, {:atom, "=="}, [
      {:application, {:atom, "{}"}, [{:atom, "a"}, {:atom, "b"}]},
      {:application, {:atom, "+"}, [{:int, 1}, {:variable, "a"}]},
    ]}
    assert Macro.to_string(Ast.to_elixir_ast(args)) == Macro.to_string(correct)
  end

  test "Work with do block" do
    correct = quote do
      unless true do
        MyTest.test
        b
      end
    end
    args = {:application, {:atom, "unless"}, [
      {:atom, "true"},
      {:do, [
        {:application, {:application, {:atom, "."}, [{:atom, "Elixir.MyTest"}, {:atom, "test"}]}, []},
        {:variable, "b"}
      ]}
    ]}
    assert Macro.to_string(Ast.to_elixir_ast(args)) == Macro.to_string(correct)
  end

  test "Work with quote block" do
    quoted = fn a -> a + 1 end
    correct = quote do
      unquote(quoted).(10)
    end
    args = {:application, {:application, {:atom, "."}, [{:quote, quoted}]}, [{:int, 10}]}
    assert Macro.to_string(Ast.to_elixir_ast(args)) == Macro.to_string(correct)
  end

end
