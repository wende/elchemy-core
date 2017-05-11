module XDebug
    exposing
        ( log
        , crash
        )

import Elmchemy exposing (..)


log : String -> a -> a
log title a =
    ffi "IO" "puts" ("#{title}:#{a}")


crash : String -> a
crash a =
    lffi "raise" (a)
