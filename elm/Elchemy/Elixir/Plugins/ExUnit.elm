module Elchemy.Plugins.ExUnit exposing (..)

import Elchemy.Elixir.Plugin exposing (Plugin)
import Elchemy.Elixir.Ast exposing (CompiledExpression, Expression(..), Value(..), dotApplication, unquote)


type ExUnitBlock context
    = Test String (context -> Bool)
    | Setup (() -> context)
    | SetupAll (() -> context)


type alias Suite context =
    Plugin (ExUnitBlock context)


suite : Suite context
suite =
    { name = "ExUnit"
    , blocks = []
    , serialize = serialize
    , setup = [ "use ExUnit.Case" ]
    }


serialize : ExUnitBlock context -> CompiledExpression
serialize block =
    case block of
        Setup body ->
            Application (Value <| Atom "setup")
                [ Do
                    [ dotApplication Quotation [ Application (Value <| Atom "{}") [] ]
                    ]
                ]
                |> unquote body

        SetupAll body ->
            Application (Value <| Atom "setup_all")
                [ Do
                    [ dotApplication Quotation [ Application (Value <| Atom "{}") [] ]
                    ]
                ]
                |> unquote body

        Test name body ->
            Application (Value <| Atom "test")
                [ Value (String name)
                , Variable "context"
                , Do
                    [ dotApplication Quotation [ Variable "context" ]
                    ]
                ]
                |> unquote body


test : String -> (context -> Bool) -> Suite context -> Suite context
test name f suite =
    { suite | blocks = Test name f :: suite.blocks }
