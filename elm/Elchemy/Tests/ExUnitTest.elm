module Elchemy.Tests.ExUnitTest exposing (..)

import Elchemy.Macros exposing (..)
import Elchemy.Plugins.ExUnit exposing (..)


testSuite : Suite Int Int Int
testSuite =
    suite "ExUnit tests work as intended" 1
        |> setupAll (Do <| \c -> c + 1)
        |> setup (Do <| \c -> c * 2)
        |> test "Context equals 4" (Do <| \c -> c == 4)
        |> test "Basic tests work as well" (Do <| \_ -> True)


meta : List Macro
meta =
    [ tests testSuite ]
