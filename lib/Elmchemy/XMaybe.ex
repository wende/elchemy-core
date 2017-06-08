
# Compiled using Elmchemy v0.3.22
defmodule Elmchemy.XMaybe do
  use Elmchemy

  @doc """
  This library fills a bunch of important niches in Elm. A `Maybe` can help
  you with optional arguments, error handling, and records with optional fields.
  
  
  # Definition
  
  @docs Maybe
  
  
  # Common Helpers
  
  @docs withDefault, map, map2, map3, map4, map5
  
  
  # Chaining Maybes
  
  @docs andThen
  
  
 
  """
  @doc """
  Represent values that may or may not exist. It can be useful if you have a
  record field that is only filled in sometimes. Or if a function takes a value
  sometimes, but does not absolutely need it.
  
 
  """
  @type maybe :: {:just, any} | :nothing

  @doc """
  Provide a default value, turning an optional value into a normal
  value. This comes in handy when paired with functions like
  [`Dict.get`](Dict#get) which gives back a `Maybe`.
  
  
      iex> import Elmchemy.XMaybe
      iex> with_default.(100).({42})
      42
  
      iex> import Elmchemy.XMaybe
      iex> with_default.(100).(nil)
      100
  
  
 
  """
  @spec with_default() :: (any -> ({any} | nil -> any))
  @spec with_default(any, {any} | nil) :: any
  curry with_default/2
  def with_default(default, maybe) do
    case maybe do
      nil ->
        default
      {value} ->
        value
    end
  end

  @doc """
  Transform a `Maybe` value with a given function:
  
  
      iex> import Elmchemy.XMaybe
      iex> map.((&+/0).().(2)).({9})
      {11}
  
      iex> import Elmchemy.XMaybe
      iex> map.((&+/0).().(2)).(nil)
      nil
  
  
 
  """
  @spec map() :: ((any -> any) -> ({any} | nil -> {any} | nil))
  curry map/2
  def map(f, maybe) do
    case maybe do
      nil ->
        nil
      {value} ->
        {f.(value)}
    end
  end

  @doc """
  Apply a function if all the arguments are `Just` a value.
  
  
      iex> import Elmchemy.XMaybe
      iex> map2.((&+/0).()).({3}).({4})
      {7}
  
      iex> import Elmchemy.XMaybe
      iex> map2.((&+/0).()).({3}).(nil)
      nil
  
      iex> import Elmchemy.XMaybe
      iex> map2.((&+/0).()).(nil).({4})
      nil
  
  
 
  """
  @spec map2() :: ((any -> (any -> any)) -> ({any} | nil -> ({any} | nil -> {any} | nil)))
  curry map2/3
  def map2(func, ma, mb) do
    case {ma, mb} do
      {{a}, {b}} ->
        {func.(a).(b)}
      _ ->
        nil
    end
  end

  @doc """
 
 
  """
  @spec map3() :: ((any -> (any -> (any -> any))) -> ({any} | nil -> ({any} | nil -> ({any} | nil -> {any} | nil))))
  curry map3/4
  def map3(func, ma, mb, mc) do
    case {ma, mb, mc} do
      {{a}, {b}, {c}} ->
        {func.(a).(b).(c)}
      _ ->
        nil
    end
  end

  @doc """
 
 
  """
  @spec map4() :: ((any -> (any -> (any -> (any -> any)))) -> ({any} | nil -> ({any} | nil -> ({any} | nil -> ({any} | nil -> {any} | nil)))))
  curry map4/5
  def map4(func, ma, mb, mc, md) do
    case {ma, mb, mc, md} do
      {{a}, {b}, {c}, {d}} ->
        {func.(a).(b).(c).(d)}
      _ ->
        nil
    end
  end

  @doc """
 
 
  """
  @spec map5() :: ((any -> (any -> (any -> (any -> (any -> any))))) -> ({any} | nil -> ({any} | nil -> ({any} | nil -> ({any} | nil -> ({any} | nil -> {any} | nil))))))
  curry map5/6
  def map5(func, ma, mb, mc, md, me) do
    case {ma, mb, mc, md, me} do
      {{a}, {b}, {c}, {d}, {e}} ->
        {func.(a).(b).(c).(d).(e)}
      _ ->
        nil
    end
  end

  @doc """
  Chain together many computations that may fail. It is helpful to see its
  definition:
  
  This means we only continue with the callback if things are going well. For
  example, say you need to use (`head : List Int -> Maybe Int`) to get the
  first month from a `List` and then make sure it is between 1 and 12:
  
  If `head` fails and results in `Nothing` (because the `List` was `empty`),
  this entire chain of operations will short-circuit and result in `Nothing`.
  If `toValidMonth` results in `Nothing`, again the chain of computations
  will result in `Nothing`.
  
  
 
  """
  @spec and_then() :: ((any -> {any} | nil) -> ({any} | nil -> {any} | nil))
  curry and_then/2
  def and_then(callback, maybe_value) do
    case maybe_value do
      {value} ->
        callback.(value)
      nil ->
        nil
    end
  end

end
