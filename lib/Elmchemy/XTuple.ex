
# Compiled using Elmchemy v0.3.25
defmodule Elmchemy.XTuple do
  use Elmchemy

  @doc """
 
  Module for tuple manipulation
  
  @docs first, second, mapFirst, mapSecond
  
 
  """
  @doc """
  Extract the first value from a tuple.
  
  
      iex> import Elmchemy.XTuple
      iex> first.({3, 4})
      3
  
      iex> import Elmchemy.XTuple
      iex> first.({"john", "doe"})
      "john"
  
 
  """
  @spec first() :: ({any, any} -> any)
  @spec first({any, any}) :: any
  curry first/1
  def first({fst, _}) do
    fst
  end

  @doc """
  Extract the second value from a tuple.
  
  
      iex> import Elmchemy.XTuple
      iex> second.({3, 4})
      4
  
      iex> import Elmchemy.XTuple
      iex> second.({"john", "doe"})
      "doe"
  
 
  """
  @spec second() :: ({any, any} -> any)
  @spec second({any, any}) :: any
  curry second/1
  def second({_, snd}) do
    snd
  end

  @doc """
  Transform the first value in a tuple.
  
  
      iex> import Elmchemy.XTuple
      iex> map_first.(XString.reverse).({"stressed", 16})
      {"desserts", 16}
  
      iex> import Elmchemy.XTuple
      iex> map_first.(XString.length).({"stressed", 16})
      {8, 16}
  
 
  """
  @spec map_first() :: ((any -> any) -> ({any, any} -> {any, any}))
  @spec map_first((any -> any), {any, any}) :: {any, any}
  curry map_first/2
  def map_first(f, {fst, snd}) do
    {f.(fst), snd}
  end

  @doc """
  Transform the second value in a tuple.
  
  
      iex> import Elmchemy.XTuple
      iex> map_second.(sqrt).({"stressed", 16})
      {"stressed", 4.0}
  
      iex> import Elmchemy.XTuple
      iex> map_second.(fn(x) -> x + 1 end).({"stressed", 16})
      {"stressed", 17}
  
 
  """
  @spec map_second() :: ((any -> any) -> ({any, any} -> {any, any}))
  @spec map_second((any -> any), {any, any}) :: {any, any}
  curry map_second/2
  def map_second(f, {fst, snd}) do
    {fst, f.(snd)}
  end

end
