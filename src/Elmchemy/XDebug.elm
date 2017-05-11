module Elmchemy.XDebug exposing
        ( log
        , crash
        )

{-| Module with helper functions for debugging

# Debug
@docs log, crash

-}

import Elmchemy exposing (..)

{-| Log to console in `title: object` format -}
log : String -> a -> a
log title a =
    ffi "IO" "puts" ("#{title}:#{a}")

{-| Raise an exception to crash the runtime. Should be avoided at all
costs. Helpful for crashing at not yet implelented functionality -}
crash : String -> a
crash a =
    lffi "raise" (a)
