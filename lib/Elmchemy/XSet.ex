
# Compiled using Elmchemy v0.3.33
defmodule Elmchemy.XSet do
  use Elmchemy

  @doc """
  A set of unique values. The values can be any comparable type. This
  includes `Int`, `Float`, `Time`, `Char`, `String`, and tuples or lists
  of comparable types.
  
  Insert, remove, and query operations all take *O(log n)* time.
  
  
  # Sets
  
  @docs Set
  
  
  # Build
  
  @docs empty, singleton, insert, remove
  
  
  # Query
  
  @docs isEmpty, member, size
  
  
  # Combine
  
  @docs union, intersect, diff
  
  
  # Lists
  
  @docs toList, fromList
  
  
  # Transform
  
  @docs map, foldl, foldr, filter, partition
  
  
 
  """
  alias XDict, as: Dict
  alias XList, as: List
  @doc """
  Represents a set of unique values. So `(Set Int)` is a set of integers and
  `(Set String)` is a set of strings.
  
 
  """
  @type set :: {:set_elm_builtin, Dict.dict}

  @doc """
  Create an empty set.
  
 
  """
  @spec empty() :: set
  def empty() do
    {:set_elm_builtin, XDict.empty}
  end

  @doc """
  Create a set with one value.
  
 
  """
  @spec singleton(any) :: set
  curry singleton/1
  def singleton(k) do
    XDict.singleton.(k).({})
    |> (:set_elm_builtin).()
  end

  @doc """
  Insert a value into a set.
  
 
  """
  @spec insert(any, set) :: set
  curry insert/2
  def insert(k, {:set_elm_builtin, d}) do
    XDict.insert.(k).({}).(d)
    |> (:set_elm_builtin).()
  end

  @doc """
  Remove a value from a set. If the value is not found, no changes are made.
  
 
  """
  @spec remove(any, set) :: set
  curry remove/2
  def remove(k, {:set_elm_builtin, d}) do
    XDict.remove.(k).(d)
    |> (:set_elm_builtin).()
  end

  @doc """
  Determine if a set is empty.
  
 
  """
  @spec is_empty(set) :: boolean
  curry is_empty/1
  def is_empty({:set_elm_builtin, d}) do
    XDict.is_empty.(d)
  end

  @doc """
  Determine if a value is in a set.
  
 
  """
  @spec member(any, set) :: boolean
  curry member/2
  def member(k, {:set_elm_builtin, d}) do
    XDict.member.(k).(d)
  end

  @doc """
  Determine the number of elements in a set.
  
 
  """
  @spec size(set) :: integer
  curry size/1
  def size({:set_elm_builtin, d}) do
    XDict.size.(d)
  end

  @doc """
  Get the union of two sets. Keep all values.
  
 
  """
  @spec union(set, set) :: set
  curry union/2
  def union({:set_elm_builtin, d1}, {:set_elm_builtin, d2}) do
    XDict.union.(d1).(d2)
    |> (:set_elm_builtin).()
  end

  @doc """
  Get the intersection of two sets. Keeps values that appear in both sets.
  
 
  """
  @spec intersect(set, set) :: set
  curry intersect/2
  def intersect({:set_elm_builtin, d1}, {:set_elm_builtin, d2}) do
    XDict.intersect.(d1).(d2)
    |> (:set_elm_builtin).()
  end

  @doc """
  Get the difference between the first set and the second. Keeps values
  that do not appear in the second set.
  
 
  """
  @spec diff(set, set) :: set
  curry diff/2
  def diff({:set_elm_builtin, d1}, {:set_elm_builtin, d2}) do
    XDict.diff.(d1).(d2)
    |> (:set_elm_builtin).()
  end

  @doc """
  Convert a set into a list, sorted from lowest to highest.
  
 
  """
  @spec to_list(set) :: list(any)
  curry to_list/1
  def to_list({:set_elm_builtin, d}) do
    XDict.keys.(d)
  end

  @doc """
  Convert a list into a set, removing any duplicates.
  
 
  """
  @spec from_list(list(any)) :: set
  curry from_list/1
  def from_list(xs) do
    XList.foldl.(insert).(empty).(xs)
  end

  @doc """
  Fold over the values in a set, in order from lowest to highest.
  
 
  """
  @spec foldl((any -> (any -> any)), any, set) :: any
  curry foldl/3
  def foldl(f, b, {:set_elm_builtin, d}) do
    XDict.foldl.(fn(k) -> fn(_) -> fn(b) -> f.(k).(b) end end end).(b).(d)
  end

  @doc """
  Fold over the values in a set, in order from highest to lowest.
  
 
  """
  @spec foldr((any -> (any -> any)), any, set) :: any
  curry foldr/3
  def foldr(f, b, {:set_elm_builtin, d}) do
    XDict.foldr.(fn(k) -> fn(_) -> fn(b) -> f.(k).(b) end end end).(b).(d)
  end

  @doc """
  Map a function onto a set, creating a new set with no duplicates.
  
 
  """
  @spec map((any -> any), set) :: set
  curry map/2
  def map(f, s) do
    from_list.(XList.map.(f).(to_list.(s)))
  end

  @doc """
  Create a new set consisting only of elements which satisfy a predicate.
  
 
  """
  @spec filter((any -> boolean), set) :: set
  curry filter/2
  def filter(p, {:set_elm_builtin, d}) do
    XDict.filter.(fn(k) -> fn(_) -> p.(k) end end).(d)
    |> (:set_elm_builtin).()
  end

  @doc """
  Create two new sets; the first consisting of elements which satisfy a
  predicate, the second consisting of elements which do not.
  
 
  """
  @spec partition((any -> boolean), set) :: {set, set}
  curry partition/2
  def partition(p, {:set_elm_builtin, d}) do
    {p1, p2} = XDict.partition.(fn(k) -> fn(_) -> p.(k) end end).(d)
    {{:set_elm_builtin, p1}, {:set_elm_builtin, p2}}
  end

end
