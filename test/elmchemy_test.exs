
defmodule ElmchemyTest do
  use ExUnit.Case
  use Elmchemy

  doctest Elmchemy

  for module <- [
    Elmchemy.XBasics,
    Elmchemy.XChar,
    Elmchemy.XDate,
    Elmchemy.XDebug,
    Elmchemy.XDict,
    Elmchemy.XList,
    Elmchemy.XMaybe,
    Elmchemy.XRegex,
    Elmchemy.XResult,
    Elmchemy.XSet,
    Elmchemy.XString,
    Elmchemy.XTuple
  ] do
    typetest module
    doctest module
  end

end
