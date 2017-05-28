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


{-| Function to make a direct Elixir local call. Takes a local function name
and a tuple or single value of arguments

    lffi "to_string"

-}
lffi : String -> a
lffi a =
    Debug.crash "You can't call local ffi in a browser"


{-| Function to make a direct Elixir remote call. Takes a module name, a function name
and a tuple or single value of arguments

    ffi "Enum" "sum"

-}
ffi : String -> String -> a
ffi m f =
    Debug.crash "You can't use ffi in a browser"


{-| Function to make a direct Elixir remote call. Takes a module name, a function name
and a tuple or single value of arguments

    ffi "Enum" "sum"

-}
tryFfi : String -> String -> a
tryFfi m f =
    Debug.crash "You can't use tryFfi in a browser"


{-| Produce multiple argument anonymous function out of regular elm function.

    flambda 2 fun --> fn x1, x2 -> fun.(x1).(x2) end

-}
flambda : Int -> a -> b
flambda arity f =
    Debug.crash "You can't use foreign lambda in a browser"


{-| Wrap a function call in try catch returning Result based on wether the function throwed an error
-}
tryCatch : (() -> a) -> Result String a
tryCatch a =
    Debug.crash "You can't use 'try' in a browser"
