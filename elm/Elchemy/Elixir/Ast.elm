module Elchemy.Elixir.Ast
    exposing
        ( Expression(..)
        , CompiledExpression
        , Value(..)
        , toElixirAst
        , dotApplication
        , unquote
        , atom
        , int
        , string
        )

{-| Module responsible for representing Elixir's AST in a type-safe and Elchemy compatible
manner.
Currnetly used for creating Plugins, might be used in future for generating entire
Elchemy output.
-}

import Elchemy exposing (..)


type Expression
    = Application Expression (List Expression)
    | Variable String
    | Value Value
    | Do (List Expression)
    | List (List Expression)
    | Tuple (List Expression)
    | Quotation


type CompiledExpression
    = Compiled Expression


type Value
    = Int Int
    | String String
    | Atom String


toElixirAst : CompiledExpression -> y
toElixirAst =
    ffi "Elchemy.Elixir.NativeAst" "serialize"


unquote : x -> Expression -> CompiledExpression
unquote =
    ffi "Elchemy.Elixir.NativeAst" "substitute"



------------ Helpers -------------------------


{-| Anonymous function application
-}
dotApplication : Expression -> List Expression -> Expression
dotApplication left right =
    Application (Application (Value <| Atom ".") [ left ]) right


access : List Expression -> Expression -> Expression
access keys expression =
    List.foldl (\acc a -> Application (Application (Value <| Atom ".") [ a ]) [ acc ]) expression keys



------- Values --------


int : Int -> Expression
int =
    Int >> Value


string : String -> Expression
string =
    String >> Value


atom : String -> Expression
atom =
    Atom >> Value
