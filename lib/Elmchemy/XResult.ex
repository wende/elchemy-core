
# Compiled using Elmchemy v0.3.33
defmodule Elmchemy.XResult do
  use Elmchemy

  @doc """
  A `Result` is the result of a computation that may fail. This is a great
  way to manage errors in Elm.
  
  
  # Type and Constructors
  
  @docs Result
  
  
  # Mapping
  
  @docs map, map2, map3, map4, map5
  
  
  # Chaining
  
  @docs andThen
  
  
  # Handling Errors
  
  @docs withDefault, toMaybe, fromMaybe, mapError
  
  
 
  """
  import Elmchemy
  @doc """
  A `Result` is either `Ok` meaning the computation succeeded, or it is an
  `Err` meaning that there was some failure.
  
 
  """
  @type result :: {:ok, any} | {:err, any}

  @doc """
  If the result is `Ok` return the value, but if the result is an `Err` then
  return a given default value. The following examples try to parse integers.
  
  
      iex> import Elmchemy.XResult
      iex> XResult.with_default.(0).(XString.to_int.("123"))
      123
  
      iex> import Elmchemy.XResult
      iex> XResult.with_default.(0).(XString.to_int.("abc"))
      0
  
  
 
  """
  @spec with_default(any, result) :: any
  curry with_default/2
  def with_default(def, result) do
    case result do
      {:ok, a} ->
        a
      {:error, _} ->
        def
    end
  end

  @doc """
  Apply a function to a result. If the result is `Ok`, it will be converted.
  If the result is an `Err`, the same error value will propagate through.
  
  
      iex> import Elmchemy.XResult
      iex> map.(sqrt).({:ok, 4.0})
      {:ok, 2.0}
  
      iex> import Elmchemy.XResult
      iex> map.(sqrt).({:error, "bad input"})
      {:error, "bad input"}
  
  
 
  """
  @spec map((any -> any), result) :: result
  curry map/2
  def map(func, ra) do
    case ra do
      {:ok, a} ->
        {:ok, func.(a)}
      {:error, e} ->
        {:error, e}
    end
  end

  @doc """
  Apply a function to two results, if both results are `Ok`. If not,
  the first argument which is an `Err` will propagate through.
  
  
      iex> import Elmchemy.XResult
      iex> map2.((&+/0).()).(XString.to_int.("1")).(XString.to_int.("2"))
      {:ok, 3}
  
      iex> import Elmchemy.XResult
      iex> map2.((&+/0).()).(XString.to_int.("1")).(XString.to_int.("y"))
      {:error, "could not convert string 'y' to an Int"}
  
      iex> import Elmchemy.XResult
      iex> map2.((&+/0).()).(XString.to_int.("x")).(XString.to_int.("y"))
      {:error, "could not convert string 'x' to an Int"}
  
  
 
  """
  @spec map2((any -> (any -> any)), result, result) :: result
  curry map2/3
  def map2(func, ra, rb) do
    case {ra, rb} do
      {{:ok, a}, {:ok, b}} ->
        {:ok, func.(a).(b)}
      {{:error, x}, _} ->
        {:error, x}
      {_, {:error, x}} ->
        {:error, x}
    end
  end

  @doc """
 
 
  """
  @spec map3((any -> (any -> (any -> any))), result, result, result) :: result
  curry map3/4
  def map3(func, ra, rb, rc) do
    case {ra, rb, rc} do
      {{:ok, a}, {:ok, b}, {:ok, c}} ->
        {:ok, func.(a).(b).(c)}
      {{:error, x}, _, _} ->
        {:error, x}
      {_, {:error, x}, _} ->
        {:error, x}
      {_, _, {:error, x}} ->
        {:error, x}
    end
  end

  @doc """
 
 
  """
  @spec map4((any -> (any -> (any -> (any -> any)))), result, result, result, result) :: result
  curry map4/5
  def map4(func, ra, rb, rc, rd) do
    case {ra, rb, rc, rd} do
      {{:ok, a}, {:ok, b}, {:ok, c}, {:ok, d}} ->
        {:ok, func.(a).(b).(c).(d)}
      {{:error, x}, _, _, _} ->
        {:error, x}
      {_, {:error, x}, _, _} ->
        {:error, x}
      {_, _, {:error, x}, _} ->
        {:error, x}
      {_, _, _, {:error, x}} ->
        {:error, x}
    end
  end

  @doc """
 
 
  """
  @spec map5((any -> (any -> (any -> (any -> (any -> any))))), result, result, result, result, result) :: result
  curry map5/6
  def map5(func, ra, rb, rc, rd, re) do
    case {ra, rb, rc, rd, re} do
      {{:ok, a}, {:ok, b}, {:ok, c}, {:ok, d}, {:ok, e}} ->
        {:ok, func.(a).(b).(c).(d).(e)}
      {{:error, x}, _, _, _, _} ->
        {:error, x}
      {_, {:error, x}, _, _, _} ->
        {:error, x}
      {_, _, {:error, x}, _, _} ->
        {:error, x}
      {_, _, _, {:error, x}, _} ->
        {:error, x}
      {_, _, _, _, {:error, x}} ->
        {:error, x}
    end
  end

  @doc """
  Chain together a sequence of computations that may fail. It is helpful
  to see its definition:
  
  This means we only continue with the callback if things are going well. For
  example, say you need to use (`toInt : String -> Result String Int`) to parse
  a month and make sure it is between 1 and 12:
  
  This allows us to come out of a chain of operations with quite a specific error
  message. It is often best to create a custom type that explicitly represents
  the exact ways your computation may fail. This way it is easy to handle in your
  code.
  
  
 
  """
  @spec and_then((any -> result), result) :: result
  curry and_then/2
  def and_then(callback, result) do
    case result do
      {:ok, value} ->
        callback.(value)
      {:error, msg} ->
        {:error, msg}
    end
  end

  @doc """
  Transform an `Err` value. For example, say the errors we get have too much
  information:
  
  
      iex> import Elmchemy.XResult
      iex> map_error.(XTuple.first).({:ok, {123, 1}})
      {:ok, {123, 1}}
  
      iex> import Elmchemy.XResult
      iex> map_error.(XTuple.second).({:error, {"nothing", "important"}})
      {:error, "important"}
  
  
 
  """
  @spec map_error((any -> any), result) :: result
  curry map_error/2
  def map_error(f, result) do
    case result do
      {:ok, v} ->
        {:ok, v}
      {:error, e} ->
        {:error, f.(e)}
    end
  end

  @doc """
  Convert to a simpler `Maybe` if the actual error message is not needed or
  you need to interact with some code that primarily uses maybes.
  
 
  """
  @spec to_maybe(result) :: {any} | nil
  curry to_maybe/1
  def to_maybe({:ok, v}) do
    {v}
  end
  def to_maybe({:error, _}) do
    nil
  end

  @doc """
  Convert from a simple `Maybe` to interact with some code that primarily
  uses `Results`.
  
 
  """
  @spec from_maybe(any, {any} | nil) :: result
  curry from_maybe/2
  def from_maybe(err, maybe) do
    case maybe do
      {v} ->
        {:ok, v}
      nil ->
        {:error, err}
    end
  end

end
