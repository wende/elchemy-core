
defmodule ElmchemyTest do
  use ExUnit.Case
  use Elmchemy

  doctest Elmchemy

  typetest Elmchemy.XBasics
  doctest Elmchemy.XBasics

  typetest Elmchemy.XList
  doctest Elmchemy.XList

  typetest Elmchemy.XString
  doctest Elmchemy.XString

  typetest Elmchemy.XMaybe
  doctest Elmchemy.XMaybe

  typetest Elmchemy.XChar
  doctest Elmchemy.XChar

  typetest Elmchemy.XResult
  doctest Elmchemy.XResult

  typetest Elmchemy.XTuple
  doctest Elmchemy.XTuple

end
