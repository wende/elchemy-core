module Elchemy.Elixir.Plugin exposing (Plugin, compile)

{-| Used to allow usage of macros inside Elchemy
-}

import Elchemy.Elixir.Ast exposing (Expression(..))


type alias Plugin a inject =
    { name : String
    , setup : List String
    , blocks : List a
    , serialize : a -> Expression inject
    }


type alias CompiledPlugin inject =
    { name : String
    , setup : List String
    , ast : List (Expression inject)
    }


compile : Plugin a inject -> CompiledPlugin inject
compile plugin =
    { name = plugin.name
    , setup = plugin.setup
    , ast = List.map plugin.serialize plugin.blocks
    }
