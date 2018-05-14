module Elchemy.Macros exposing (Macro(..), Do(..), macro, use, behaviour)

{-| This module is responsible for defining and using macros in Plugins system for Elchemy.
To use this module you need to import it to your module and use its constructs in the
`meta` definition of your module.

@docs Macro, Do, macro, use, behaviour

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


{-| FFI function that creates a new macro calling an Elixir function that returns Elixir ast.
For instance:

    myMacro : Macro
    myMacro =
        macro "ModuleContainingAstFunction" "ast_function"

Notice that the function *always* returns a Macro type so that it can only be used in `meta` definition
of a module. That ensures that macros are only called top level, everything in deeper scopes -
like inside functions should only be handled using functions.

-}
macro : String -> String -> a
macro m f =
    Debug.crash "You can't use macro in a browser"


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
