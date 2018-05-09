module Elchemy.Macros exposing (Macro(..), Do(..), use, behaviour)

{- ex
   def use_macro(mod) do
     module = :"Elixir.#{mod}"
     quote do
       use unquote(module)
     end
   end

   def behaviour_macro(mod) do
     module = :"Elixir.#{mod}"
     quote do
       @behaviour unquote(module)
     end
   end
-}

import Elchemy exposing (..)


{-| Type of macro expression that go into 'meta' function in a module
-}
type Macro
    = Macro


{-| Declares a block that doesn't get evaluated eagerly but rather passed as an AST to be used later in a macro
-}
type Do x
    = Do x


use : String -> Macro
use =
    macro "Elchemy.Elixir.Macros" "use_macro"


behaviour : String -> Macro
behaviour =
    macro "Elchemy.Elixir.Macros" "behaviour_macro"
