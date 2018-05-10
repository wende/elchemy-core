module Elchemy.Macros exposing (Macro(..), Do(..), use, behaviour)

{-| This module is responsible for defining and using macros in Plugins system for Elchemy.
To use this module you need to import it to your module and use its constructs in the
`meta` definition of your module.

@docs Macro, Do, use, behaviour

-}

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


{-| Use macro is a simple wrapper around Elixir.SpecialForms.use
-}
use : String -> Macro
use =
    macro "Elchemy.Elixir.Macros" "use_macro"


{-| Use macro is a simple wrapper around @behaviour module attribute.
-}
behaviour : String -> Macro
behaviour =
    macro "Elchemy.Elixir.Macros" "behaviour_macro"
