module Elmchemy.XDebug
    exposing
        ( log
        , crash
        )

{-| Module with helper functions for debugging


# Debug

@docs log, crash

-}

import Elmchemy exposing (..)


{-| Log to console in `title: object` format
-}
log : String -> a -> a
log title a =
    let
        _ =
            puts_ "#{title}:#{a}" []
    in
        a


puts_ : a -> List ( key, val ) -> a
puts_ =
    ffi "IO" "inspect"



{- We don't verify since it's a macro -}
{- flag noverify:+crash -}


{-| Raise an exception to crash the runtime. Should be avoided at all
costs. Helpful for crashing at not yet implelented functionality
-}
crash : String -> a
crash =
    ffi "Kernel" "raise"
