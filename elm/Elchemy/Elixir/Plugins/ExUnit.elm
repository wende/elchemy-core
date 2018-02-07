module Elchemy.Plugins.ExUnit exposing (..)

import Elchemy.Elixir.Plugin exposing (Plugin)
import Elchemy.Elixir.Ast exposing (Expression(..), Value(..), dotApplication)


type ExUnitBlock context
    = Test String (context -> Bool)


suite : Plugin (ExUnitBlock context) (context -> Bool)
suite =
    { name = "ExUnit"
    , blocks = []
    , serialize = serialize
    , setup = [ "use ExUnit.Case" ]
    }


serialize : ExUnitBlock context -> Expression (context -> Bool)
serialize block =
    case block of
        Test name body ->
            Application (Value <| Atom "test")
                [ Value (String name)
                , Variable "context"
                , Do
                    [ dotApplication (Quote body) [ Variable "context" ]
                    ]
                ]
