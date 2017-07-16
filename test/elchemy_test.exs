defmodule Helpers do
  defmacro gen_tests(tests) do
    for mod <- tests do
      quote do
        typetest unquote(mod)
        doctest unquote(mod)
      end
    end
  end
end

defmodule ElchemyTest do
  use ExUnit.Case
  use Elchemy
  import Helpers

  doctest Elchemy

  gen_tests([
    Elchemy.XBasics,
    Elchemy.XList,
    Elchemy.XString,
    Elchemy.XMaybe,
    Elchemy.XChar,
    Elchemy.XResult,
    Elchemy.XTuple,
    # Elchemy.XDebug, -- Debug loops forerever
    Elchemy.XDict
  ])

end
