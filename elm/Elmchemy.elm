module Elmchemy
    exposing
        ( lffi
        , ffi
        , tryFfi
        , flambda
        , tryCatch
        )

{-| Module to help express some Elixir related types and calls that wouldn't otherwise be possible

@docs lffi, ffi, tryFfi , flambda, tryCatch

-}


{-| *Deprecated since Elmchemy 0.3.0*
Function to make a direct Elixir local call. Takes a local function name
and a tuple or single value of arguments

    lffi "to_string"

-}
lffi : String -> a
lffi a =
    Debug.crash "You can't call local ffi in a browser"


{-| Function to make a direct Elixir remote call. Takes a module name and a function name
Ffi functions must be the only call in the entire function and the type declaration
is mandatory. For example

    mySum : List number -> number
    mySum =
        ffi "Enum" "sum"

That function will call `Enum.sum(list)` on our parameter, and also it will generate
a type verification macro, that makes sure, that `Enum.sum/1` actually returns
our type (List number -> number).
To actiate the typecheck put

    typetest MyModule

inside of your test suite

-}
ffi : String -> String -> a
ffi m f =
    Debug.crash "You can't use ffi in a browser"


{-| Function to make a direct Elixir remote call. Takes a module name, a function name
and a tuple or single value of arguments. tryFfi verifies no types at compile time
but it makes sure the value you're requesting is what you're expecting wrappend
in Result.Ok Type, or otherwise you get a Result.Error String

    myToFloat : String -> Result Float
    myToFloat =
        ffi "Kernel" "to_float"

-}
tryFfi : String -> String -> a
tryFfi m f =
    Debug.crash "You can't use tryFfi in a browser"


{-| *Deprecated since Elmchemy 0.3.0*

Produce multiple argument anonymous function out of regular elm function.

    flambda 2 fun --> fn x1, x2 -> fun.(x1).(x2) end

-}
flambda : Int -> a -> b
flambda arity f =
    Debug.crash "You can't use foreign lambda in a browser"


{-| *Deprecated since Elmchemy 0.3.0*

Wrap a function call in try catch returning Result based on wether the function throwed an error

-}
tryCatch : (() -> a) -> Result String a
tryCatch a =
    Debug.crash "You can't use 'try' in a browser"
