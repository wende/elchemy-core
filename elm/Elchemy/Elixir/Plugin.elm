module Elchemy.Elixir.Plugin exposing (Plugin, compile)

{-| Used to allow usage of macros inside Elchemy
-}

import Elchemy.Elixir.Ast exposing (CompiledExpression, Expression(..))


type alias Plugin a =
    { name : String
    , setup : List String
    , blocks : List a
    , serialize : a -> CompiledExpression
    }


type alias CompiledPlugin =
    { name : String
    , setup : List String
    , ast : List CompiledExpression
    }


compile : Plugin a -> CompiledPlugin
compile plugin =
    { name = plugin.name
    , setup = plugin.setup
    , ast = List.map plugin.serialize plugin.blocks
    }
