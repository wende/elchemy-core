module Elchemy.XBitwise exposing
  ( and, or, xor, complement
  , shiftLeftBy, shiftRightBy, shiftRightZfBy
  )

{-| Library for [bitwise operations](http://en.wikipedia.org/wiki/Bitwise_operation).
# Basic Operations
@docs and, or, xor, complement
# Bit Shifts
@docs shiftLeftBy, shiftRightBy, shiftRightZfBy
-}

{- ex
  use Bitwise
-}

import Elchemy exposing (..)

integerBitSize = 32

{-| Bitwise AND

    and 0 0 == 0
    and 1 1 == 1
    and 4 1 == 0
    and 102939 1 == 1

-- truncates to 32 bits
    and 92147483647 -1 == 1953170431

-}
and : Int -> Int -> Int
and arg1 arg2 =
    nativeAnd (to32Bits arg1) (to32Bits arg2)

nativeAnd : Int -> Int -> Int
nativeAnd =
  ffi "Bitwise" "band"


{-| Bitwise OR

    or 0 0 == 0
    or 1 1 == 1
    or 4 1 == 5
    or 102939 1 == 102939

-}
or : Int -> Int -> Int
or =
  ffi "Bitwise" "bor"


{-| Bitwise XOR

    Bitwise.xor 0 0 == 0
    Bitwise.xor 1 1 == 0
    Bitwise.xor 4 1 == 5
    Bitwise.xor 102939 1 == 102938

-}
xor : Int -> Int -> Int
xor =
  ffi "Bitwise" "bxor"


{-| Flip each bit individually, often called bitwise NOT

    complement 0 == -1
    complement 1 == -2
    complement 102939 == -102940

-}
complement : Int -> Int
complement =
  ffi "Bitwise" "bnot"


{-| Shift bits to the left by a given offset, filling new bits with zeros.
This can be used to multiply numbers by powers of two.
    shiftLeftBy 1 5 == 10
    shiftLeftBy 5 1 == 32
-}
shiftLeftBy : Int -> Int -> Int
shiftLeftBy shift int =
    swappedShiftLeftBy int shift


{- Swaps the argument order for ffi
-}
swappedShiftLeftBy : Int -> Int -> Int
swappedShiftLeftBy =
    ffi "Bitwise" "bsl"


{-| Shift bits to the right by a given offset, filling new bits with
whatever is the topmost bit. This can be used to divide numbers by powers of two.
    shiftRightBy 1  32 == 16
    shiftRightBy 2  32 == 8
    shiftRightBy 1 -32 == -16
This is called an [arithmetic right shift][ars], often written (>>), and
sometimes called a sign-propagating right shift because it fills empty spots
with copies of the highest bit.
[ars]: http://en.wikipedia.org/wiki/Bitwise_operation#Arithmetic_shift
-}
shiftRightBy : Int -> Int -> Int
shiftRightBy shift int =
  nativeShiftRightBy int shift


{- Swaps the argument order for ffi
-}
nativeShiftRightBy : Int -> Int -> Int
nativeShiftRightBy =
  ffi "Bitwise" "bsr"

{-| Shift bits to the right by a given offset, filling new bits with zeros.
    shiftRightZfBy 1  32 == 16
    shiftRightZfBy 2  32 == 8
    shiftRightZfBy 1 -32 == 2147483632
This is called an [logical right shift][lrs], often written (>>>), and
sometimes called a zero-fill right shift because it fills empty spots with
zeros.
[lrs]: http://en.wikipedia.org/wiki/Bitwise_operation#Logical_shift
-}
shiftRightZfBy : Int -> Int -> Int
shiftRightZfBy shift int =
  shiftRightBy shift int
  |> and (mask shift)

to32Bits : Int -> Int
to32Bits int =
    int |> and (mask 0)

mask : Int -> Int
mask bits =
    (shiftLeftBy (integerBitSize - bits) 1) - 1
