
defmodule ElchemyTest do
  use ExUnit.Case
  use Elchemy

  doctest Elchemy

  typetest Elchemy.XBasics
  doctest Elchemy.XBasics

  typetest Elchemy.XList
  doctest Elchemy.XList

  typetest Elchemy.XString
  doctest Elchemy.XString

  typetest Elchemy.XMaybe
  doctest Elchemy.XMaybe

  typetest Elchemy.XChar
  doctest Elchemy.XChar

  typetest Elchemy.XResult
  doctest Elchemy.XResult

  typetest Elchemy.XTuple
  doctest Elchemy.XTuple

end
