module Elchemy.Elixir.Ast exposing (Expression(..), Value(..), toElixirAst, dotApplication)

import Elchemy exposing (..)


type Expression x
    = Application (Expression x) (List (Expression x))
    | Variable String
    | Value Value
    | Do (List (Expression x))
    | Quote x


type Value
    = Int Int
    | String String
    | Atom String


toElixirAst : Expression x -> y
toElixirAst =
    ffi "Elchemy.Elixir.NativeAst" "serialize"


{-| Anonymous function application
-}
dotApplication : Expression x -> List (Expression x) -> Expression x
dotApplication left right =
    Application (Application (Value <| Atom ".") [ left ]) right
