module Elchemy.Plugins.ExUnit exposing (..)

import Elchemy exposing (..)
import Elchemy.Macros exposing (..)


{- ex
   @doc "Macro to include this file into tests in *.exs files"
   defmacro test(mod) do
     {mod, []} = Code.eval_quoted(mod)
     mod.tests()
   end
-}


type Test c
    = Test String (Do (c -> Bool))


type Setup c1 c2
    = Setup (Do (c1 -> c2))


type alias Suite initialContext context testContext =
    { name : String
    , initialValue : initialContext
    , setupAll : Setup initialContext context
    , setup : Setup context testContext
    , tests : List (Test testContext)
    }


suite : String -> c -> Suite c c c
suite name initialValue =
    { name = name
    , initialValue = initialValue
    , setupAll = Setup (Do <| \a -> a)
    , setup = Setup (Do <| \a -> a)
    , tests = []
    }


tests : Suite c1 c2 c3 -> Macro
tests =
    macro "Elchemy.Plugins.NativeExUnit" "define_tests"


test : String -> Do (c3 -> Bool) -> Suite c1 c2 c3 -> Suite c1 c2 c3
test name f suite =
    { suite | tests = Test name f :: suite.tests }


setup : Do (c2 -> c3) -> Suite c1 c2 c3 -> Suite c1 c2 c3
setup f suite =
    { suite | setup = Setup f }


setupAll : Do (c1 -> c2) -> Suite c1 c2 c3 -> Suite c1 c2 c3
setupAll f suite =
    { suite | setupAll = Setup f }
