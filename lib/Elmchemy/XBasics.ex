
# Compiled using Elmchemy v0.3.22
defmodule Elmchemy.XBasics do
  use Elmchemy

  @doc """
  Tons of useful functions that get imported by default.
  @docs compare, xor, sqrt, clamp, compare , xor , negate , sqrt , logBase , e , pi , cos , sin , tan , acos , asin , atan , atan2 , round , floor , ceiling , truncate , toFloat , toString , (++) , identity , always, flip, tuple2, tuple3, tuple4, tuple5
  
  @docs Order
  
  
 
  """
  import Elmchemy
  @doc """
  Represents the relative ordering of two things.
  The relations are less than, equal to, and greater than.
  
 
  """
  @type order :: :lt | :eq | :gt

  #  Operators


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


  @doc """
  Basic compare function
  
  
  ### Example
  
  
      iex> import Elmchemy.XBasics
      iex> compare.(1).(2)
      :lt
  
  
 
  """
  @spec compare() :: (any -> (any -> order))
  @spec compare(any, any) :: order
  curry compare/2
  def compare(a, b) do
    cond do
      a > b -> :gt
      a < b -> :lt
      true -> :eq
    end
  end


  # >> is replaced with >>> by the compiler
  def l >>> r do
  fn x -> r.(l.(x)) end
  end


  #  not/1 is inlined by the compiler
  @doc """
  The exclusive-or operator. `True` if exactly one input is `True`.
  
 
  """
  @spec xor() :: (boolean -> (boolean -> boolean))
  @spec xor(boolean, boolean) :: boolean
  curry xor/2
  def xor(a, b) do
    a && (&!/0).().(b) || (&!/0).().(a) && b
  end

  @doc """
  Negate a number.
  
  
      iex> import Elmchemy.XBasics
      iex> negate.(42)
      -42
  
      iex> import Elmchemy.XBasics
      iex> negate.(-42)
      42
  
      iex> import Elmchemy.XBasics
      iex> negate.(0)
      0
  
  
 
  """
  @spec negate() :: (number -> number)
  @spec negate(number) :: number
  curry negate/1
  verify as: Kernel.-/1
  def negate(a1), do: Kernel.-(a1)
  @doc """
  Take the square root of a number.
  
 
  """
  @spec sqrt() :: (number -> float)
  @spec sqrt(number) :: float
  curry sqrt/1
  verify as: :math.sqrt/1
  def sqrt(a1), do: :math.sqrt(a1)
  @doc """
  Clamps a number within a given range. With the expression
  `clamp 100 200 x` the results are as follows:
  100 if x < 100
  x if 100 <= x < 200
  200 if 200 <= x
  
 
  """
  @spec clamp() :: (any -> (any -> (any -> any)))
  @spec clamp(any, any, any) :: any
  curry clamp/3
  def clamp(x, bottom, top) do
    x
    |> (min.(bottom)).()
    |> (max.(top)).()
  end

  @doc """
 
 
  """
  @spec log_base() :: (float -> (float -> float))
  @spec log_base(float, float) :: float
  curry log_base/2
  def log_base(a, b) do
    not_implemented
  end

  @doc """
 
 
  """
  @spec e() :: float
  def e() do
    2.71828
  end

  @doc """
 
 
  """
  @spec pi() :: float
  verify as: :math.pi/0
  def pi(), do: :math.pi()
  @doc """
 
 
  """
  @spec cos() :: (float -> float)
  @spec cos(float) :: float
  curry cos/1
  verify as: :math.cos/1
  def cos(a1), do: :math.cos(a1)
  @doc """
 
 
  """
  @spec sin() :: (float -> float)
  @spec sin(float) :: float
  curry sin/1
  verify as: :math.sin/1
  def sin(a1), do: :math.sin(a1)
  @doc """
 
 
  """
  @spec tan() :: (float -> float)
  @spec tan(float) :: float
  curry tan/1
  verify as: :math.tan/1
  def tan(a1), do: :math.tan(a1)
  @doc """
 
 
  """
  @spec acos() :: (float -> float)
  @spec acos(float) :: float
  curry acos/1
  verify as: :math.acos/1
  def acos(a1), do: :math.acos(a1)
  @doc """
 
 
  """
  @spec asin() :: (float -> float)
  @spec asin(float) :: float
  curry asin/1
  verify as: :math.asin/1
  def asin(a1), do: :math.asin(a1)
  @doc """
 
 
  """
  @spec atan() :: (float -> float)
  @spec atan(float) :: float
  curry atan/1
  verify as: :math.atan/1
  def atan(a1), do: :math.atan(a1)
  @doc """
 
 
  """
  @spec atan2() :: (float -> (float -> float))
  @spec atan2(float, float) :: float
  curry atan2/2
  verify as: :math.atan2/2
  def atan2(a1, a2), do: :math.atan2(a1, a2)
  @doc """
 
 
  """
  @spec round() :: (float -> integer)
  @spec round(float) :: integer
  curry round/1
  verify as: Kernel.round/1
  def round(a1), do: Kernel.round(a1)
  @doc """
 
 
  """
  @spec floor() :: (float -> integer)
  @spec floor(float) :: integer
  curry floor/1
  def floor(x) do
    not_implemented
  end

  @doc """
 
 
  """
  @spec ceiling() :: (float -> integer)
  @spec ceiling(float) :: integer
  curry ceiling/1
  def ceiling(x) do
    not_implemented
  end

  @doc """
  Truncate a number, rounding towards zero.
  
 
  """
  @spec truncate() :: (float -> integer)
  @spec truncate(float) :: integer
  curry truncate/1
  def truncate(x) do
    not_implemented
  end

  @doc """
  Convert an integer into a float.
  
 
  """
  @spec to_float() :: (integer -> float)
  @spec to_float(integer) :: float
  curry to_float/1
  def to_float(x) do
    mul_.(x).(1.0)
  end

  @spec mul_() :: (integer -> (float -> float))
  @spec mul_(integer, float) :: float
  curryp mul_/2
  verify as: Kernel.*/2
  def mul_(a1, a2), do: Kernel.*(a1, a2)
  @doc """
  Turn any kind of value into a string. When you view the resulting string
  with `Text.fromString` it should look just like the value it came from.
  
  
      iex> import Elmchemy.XBasics
      iex> to_string.(42)
      "42"
  
      iex> import Elmchemy.XBasics
      iex> to_string.([1, 2])
      "[1, 2]"
  
  
 
  """
  @spec to_string() :: (any -> String.t)
  @spec to_string(any) :: String.t
  curry to_string/1
  def to_string(a) do
    inspect_.(a).([])
  end

  @type binaries_as :: :as_binaries | :as_strings

  @type inspect_option :: {:structs, boolean} | {:binaries, binaries_as}

  @spec inspect_() :: (any -> (list(inspect_option) -> String.t))
  @spec inspect_(any, list(inspect_option)) :: String.t
  curryp inspect_/2
  verify as: Kernel.inspect/2
  def inspect_(a1, a2), do: Kernel.inspect(a1, a2)
  @doc """
  Put two appendable things together. This includes strings, lists, and text.
  
  
      iex> import Elmchemy.XBasics
      iex> "hello" ++ "world"
      "helloworld"
  
      iex> import Elmchemy.XBasics
      iex> [1, 1, 2] ++ [3, 5, 8]
      [1, 1, 2, 3, 5, 8]
  
  
 
  """
  curry ++/2
  def a ++ b do
    if is_binary_.(a) && is_binary_.(b) do add_strings_.(a).(b) else add_lists_.(a).(b) end
  end

  @spec is_binary_() :: (any -> boolean)
  @spec is_binary_(any) :: boolean
  curryp is_binary_/1
  verify as: Kernel.is_binary/1
  def is_binary_(a1), do: Kernel.is_binary(a1)
  @spec add_strings_() :: (any -> (any -> any))
  @spec add_strings_(any, any) :: any
  curryp add_strings_/2
  def add_strings_(a1, a2), do: Kernel.<>(a1, a2)
  @spec add_lists_() :: (any -> (any -> any))
  @spec add_lists_(any, any) :: any
  curryp add_lists_/2
  def add_lists_(a1, a2), do: Kernel.++(a1, a2)
  @doc """
  Given a value, returns exactly the same value. This is called
  [the identity function](http://en.wikipedia.org/wiki/Identity_function).
  
 
  """
  @spec identity() :: (any -> any)
  @spec identity(any) :: any
  curry identity/1
  def identity(a) do
    a
  end

  @doc """
  Create a function that *always* returns the same value. Useful with
  functions like `map`:
  
  
      iex> import Elmchemy.XBasics
      iex> XList.map.(always.(0)).([1, 2, 3, 4, 5])
      [0, 0, 0, 0, 0]
  
      iex> import Elmchemy.XBasics
      iex> XList.map.(fn(_) -> 0 end).([1, 2, 3, 4, 5])
      [0, 0, 0, 0, 0]
  
  
 
  """
  @spec always() :: (any -> (any -> any))
  @spec always(any, any) :: any
  curry always/2
  def always(a, b) do
    a
  end

  @doc """
  Flip the order of the first two arguments to a function.
  
 
  """
  @spec flip() :: ((any -> (any -> any)) -> (any -> (any -> any)))
  @spec flip((any -> (any -> any)), any, any) :: any
  curry flip/3
  def flip(f, a, b) do
    f.(b).(a)
  end

  #  TODO Will be fixed with #34

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


  #  We don't care for Never type
  #  Additional
  @spec not_implemented() :: any
  defp not_implemented() do
    _ = throw_.("Not implemented")
    Debug.crash.("a")
  end

  @spec throw_() :: (String.t -> no_return)
  @spec throw_(String.t) :: no_return
  curryp throw_/1
  verify as: Kernel.throw/1
  def throw_(a1), do: Kernel.throw(a1)
  @doc """
 
 
  """
  @spec tuple2() :: (any -> (any -> {any, any}))
  @spec tuple2(any, any) :: {any, any}
  curry tuple2/2
  def tuple2(a, b) do
    {a, b}
  end

  @doc """
 
 
  """
  @spec tuple3() :: (any -> (any -> (any -> {any, any, any})))
  @spec tuple3(any, any, any) :: {any, any, any}
  curry tuple3/3
  def tuple3(a, b, c) do
    {a, b, c}
  end

  @doc """
 
 
  """
  @spec tuple4() :: (any -> (any -> (any -> (any -> {any, any, any, any}))))
  @spec tuple4(any, any, any, any) :: {any, any, any, any}
  curry tuple4/4
  def tuple4(a, b, c, d) do
    {a, b, c, d}
  end

  @doc """
 
 
  """
  @spec tuple5() :: (any -> (any -> (any -> (any -> (any -> {any, any, any, any, any})))))
  @spec tuple5(any, any, any, any, any) :: {any, any, any, any, any}
  curry tuple5/5
  def tuple5(a, b, c, d, e) do
    {a, b, c, d, e}
  end

end
