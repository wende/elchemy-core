module Elmchemy.XBasics
    exposing
        (Order(..)
        , compare
        , xor
        , negate
        , sqrt
        , clamp
        , logBase
        , e
        , pi
        , cos
        , sin
        , tan
        , acos
        , asin
        , atan
        , atan2
        , round
        , floor
        , ceiling
        , truncate
        , toFloat
        , toString
        , (++)
        , identity
        , always
        , flip
        , tuple2
        , tuple3
        , tuple4
        , tuple5
        )

{-| Tons of useful functions that get imported by default.
@docs compare, xor, negate, sqrt, clamp, compare , xor , negate , sqrt , clamp , logBase , e , pi , cos , sin , tan , acos , asin , atan , atan2 , round , floor , ceiling , truncate , toFloat , toString , (++) , identity , always, flip, tuple2, tuple3, tuple4, tuple5

@docs Order

-}

import Elmchemy exposing (..)

{-| Represents the relative ordering of two things.
The relations are less than, equal to, and greater than.
-}
type Order
    = LT
    | EQ
    | GT



-- Operators
{- ex

   import Kernel, except: [
     {:'++', 2},
     {:round, 1},
     {:to_string, 1}

   ]

   curry ==/2
   curry !=/2
   curry </2
   curry >/2
   curry <=/2
   curry >=/2
   curry max/2
   curry min/2

   curry &&/2
   curry ||/2

   curry +/2
   curry -/2
   curry */2
   curry //2
   curry div/2
   curry rem/2
   curry abs/1
   # Inlined from not
   curry !/1

-}


{-| Basic compare function


### Example

    compare 1 2 == LT

-}
compare : comparable -> comparable -> Order
compare a b =
    if a > b then
        GT
    else if a < b then
        LT
    else
        EQ



{- ex
   # >> is replaced with >>> by the compiler
   def l >>> r do
     fn x -> r.(l.(x)) end
   end

-}
-- not/1 is inlined by the compiler

{-| The exclusive-or operator. `True` if exactly one input is `True`. -}
xor : Bool -> Bool -> Bool
xor a b =
    (a && not b) || (not a && b)

{-| Negate a number.
    negate 42 == -42
    negate -42 == 42
    negate 0 == 0
 -}
negate : number -> number
negate x =
    lffi "-" x

{-| Take the square root of a number. -}
sqrt : number -> Float
sqrt x =
    ffi ":math" "sqrt" x

{-| Clamps a number within a given range. With the expression
`clamp 100 200 x` the results are as follows:
  100     if x < 100
   x      if 100 <= x < 200
  200     if 200 <= x
-}
clamp : comparable -> comparable -> comparable -> comparable
clamp x bottom top =
    x
        |> min bottom
        |> max top

{-|-}
logBase : Float -> Float -> Float
logBase a b =
    notImplemented

{-|-}
e : Float
e =
    2.71828

{-|-}
pi : Float
pi =
    lffi "apply" ( ":math", "pi", [] )

{-|-}
cos : Float -> Float
cos x =
    ffi ":math" "cos" x

{-|-}
sin : Float -> Float
sin x =
    ffi ":math" "sin" x

{-|-}
tan : Float -> Float
tan x =
    ffi ":math" "tan" x

{-|-}
acos : Float -> Float
acos x =
    ffi ":math" "acos" x

{-|-}
asin : Float -> Float
asin x =
    ffi ":math" "asin" x

{-|-}
atan : Float -> Float
atan x =
    ffi ":math" "atan" x

{-|-}
atan2 : Float -> Float -> Float
atan2 x y =
    ffi ":math" "atan2" ( x, y )

{-|-}
round : Float -> Int
round x =
    lffi "round" x

{-|-}
floor : Float -> Int
floor x =
    notImplemented

{-|-}
ceiling : Float -> Int
ceiling x =
    notImplemented

{-| Truncate a number, rounding towards zero. -}
truncate : Float -> Int
truncate x =
    notImplemented

{-| Convert an integer into a float. -}
toFloat : Int -> Float
toFloat x =
    ffi "Kernel" "*" ( x, 1.0 )

{-| Turn any kind of value into a string. When you view the resulting string
with `Text.fromString` it should look just like the value it came from.
    toString 42 == "42"
    toString [1,2] == "[1, 2]"
-}
toString : a -> String
toString x =
    ffi "Kernel" "inspect" x

{-| Put two appendable things together. This includes strings, lists, and text.
    "hello" ++ "world" == "helloworld"
    [1,1,2] ++ [3,5,8] == [1,1,2,3,5,8]
 -}
(++) : appendable -> appendable -> appendable
(++) a b =
    if lffi "is_binary" a && lffi "is_binary" b then
        ffi "Kernel" "<>" ( a, b )
    else
        ffi "Kernel" "++" ( a, b )

{-| Given a value, returns exactly the same value. This is called
[the identity function](http://en.wikipedia.org/wiki/Identity_function).
-}
identity : a -> a
identity a =
    a

{-| Create a function that *always* returns the same value. Useful with
functions like `map`:
    List.map (always 0) [1,2,3,4,5] == [0,0,0,0,0]
    List.map (\_ -> 0) [1,2,3,4,5] == [0,0,0,0,0]
-}
always : a -> a -> a
always a b =
    a



{-| Flip the order of the first two arguments to a function. -}
flip : (a -> b -> c) -> b -> a -> c
flip f a b =
    f b a



-- TODO Will be fixed with #34
{- ex
   @spec curried(({any, any} -> any)) :: ((any -> any) -> any)
   curry curried/1
   def curried(fun) do
     fn fst -> fn snd -> fun.({fst, snd}) end end
   end

   @spec uncurried(((any -> any) -> any)) :: ({any, any} -> any)
   curry uncurried/1
   def uncurried(fun) do
     fn {fst, snd} -> fun.(fst).(snd) end
   end

-}
-- We don't care for Never type
-- Additional


notImplemented : a
notImplemented =
    lffi "throw" "Not implemented"

{-|-}
tuple2 : a -> b -> ( a, b )
tuple2 a b =
    ( a, b )

{-|-}
tuple3 : a -> b -> c -> ( a, b, c )
tuple3 a b c =
    ( a, b, c )

{-|-}
tuple4 : a -> b -> c -> d -> ( a, b, c, d )
tuple4 a b c d =
    ( a, b, c, d )

{-|-}
tuple5 : a -> b -> c -> d -> e -> ( a, b, c, d, e )
tuple5 a b c d e =
    ( a, b, c, d, e )
