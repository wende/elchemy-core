
# Compiled using Elmchemy v0.3.22
defmodule Elmchemy.XList do
  use Elmchemy

  @doc """
  A library for manipulating lists of values. Every value in a
  list must have the same type.
  
  
  # Basics
  
  @docs isEmpty, length, reverse, member
  
  
  # Sub-lists
  
  @docs head, tail, filter, take, drop
  
  
  # Putting Lists Together
  
  @docs singleton, repeat, range, cons, (::), append, concat, intersperse
  
  
  # Taking Lists Apart
  
  @docs partition, unzip
  
  
  # Mapping
  
  @docs map, map2
  
  If you can think of a legitimate use of `mapN` where `N` is 6 or more, please
  let us know on [the list](https://groups.google.com/forum/#!forum/elm-discuss).
  The current sentiment is that it is already quite error prone once you get to
  4 and possibly should be approached another way.
  
  
  # Special Maps
  
  @docs filterMap, concatMap, indexedMap
  
  
  # Folding
  
  @docs foldr, foldl
  
  
  # Special Folds
  
  @docs sum, product, maximum, minimum, all, any, scanl
  
  
  # Sorting
  
  @docs sort, sortBy, sortWith
  
  
 
  """
  import Elmchemy

  import Kernel, except: [{:length, 1}]
  import Elmchemy.XBasics

  @doc """
  Add an element to the front of a list. Pronounced *cons*.
  
  
      iex> import Elmchemy.XList
      iex> [1 | [2, 3]]
      [1, 2, 3]
  
      iex> import Elmchemy.XList
      iex> [1 | []]
      [1]
  
  
 
  """
  @doc """
  Add an element to the front of a list. Pronounced *cons*.
  
  
      iex> import Elmchemy.XList
      iex> cons.(1).([2, 3])
      [1, 2, 3]
  
      iex> import Elmchemy.XList
      iex> cons.(1).([])
      [1]
  
  
 
  """
  @spec cons() :: (any -> (list(any) -> list(any)))
  @spec cons(any, list(any)) :: list(any)
  curry cons/2
  def cons(a, list) do
    [a | list]
  end

  @doc """
  Extract the first element of a list.
  
  
      iex> import Elmchemy.XList
      iex> head.([1, 2, 3])
      {1}
  
      iex> import Elmchemy.XList
      iex> head.([])
      nil
  
  
 
  """
  @spec head() :: (list(any) -> {any} | nil)
  @spec head(list(any)) :: {any} | nil
  curry head/1
  def head([x | xs]) do
    {x}
  end
  def head([]) do
    nil
  end

  @doc """
  Extract the rest of the list.
  
  
      iex> import Elmchemy.XList
      iex> tail.([1, 2, 3])
      {[2, 3]}
  
      iex> import Elmchemy.XList
      iex> tail.([])
      nil
  
  
 
  """
  @spec tail() :: (list(any) -> {list(any)} | nil)
  @spec tail(list(any)) :: {list(any)} | nil
  curry tail/1
  def tail([x | xs]) do
    {xs}
  end
  def tail([]) do
    nil
  end

  @doc """
  Determine if a list is empty.
  
  
      iex> import Elmchemy.XList
      iex> is_empty.([])
      :true
  
  
 
  """
  @spec is_empty() :: (list(any) -> boolean)
  @spec is_empty(list(any)) :: boolean
  curry is_empty/1
  def is_empty([]) do
    :true
  end
  def is_empty(_) do
    :false
  end

  @doc """
  Figure out whether a list contains a value.
  
  
      iex> import Elmchemy.XList
      iex> member.(9).([1, 2, 3, 4])
      :false
  
      iex> import Elmchemy.XList
      iex> member.(4).([1, 2, 3, 4])
      :true
  
  
 
  """
  @spec member() :: (any -> (list(any) -> boolean))
  @spec member(any, list(any)) :: boolean
  curry member/2
  def member(x, xs) do
    any.(fn(a) -> a == x end).(xs)
  end

  @doc """
  Apply a function to every element of a list.
  
  
      iex> import Elmchemy.XList
      iex> map.(sqrt).([1, 4, 9])
      [1.0, 2.0, 3.0]
  
  
      iex> import Elmchemy.XList
      iex> map.((&!/0).()).([:true, :false, :true])
      [:false, :true, :false]
  
  
 
  """
  @spec map() :: ((any -> any) -> (list(any) -> list(any)))
  @spec map((any -> any), list(any)) :: list(any)
  curry map/2
  def map(f, xs) do
    foldr.(fn(x) -> fn(acc) -> [f.(x) | acc] end end).([]).(xs)
  end

  @doc """
  Same as `map` but the function is also applied to the index of each
  element (starting at zero).
  
  
      iex> import Elmchemy.XList
      iex> indexed_map.((&tuple2/0).()).(["Tom", "Sue", "Bob"])
      [{0, "Tom"}, {1, "Sue"}, {2, "Bob"}]
  
  
 
  """
  @spec indexed_map() :: ((integer -> (any -> any)) -> (list(any) -> list(any)))
  @spec indexed_map((integer -> (any -> any)), list(any)) :: list(any)
  curry indexed_map/2
  def indexed_map(f, xs) do
    map2.(f).(range.(0).(length.(xs) - 1)).(xs)
  end

  @doc """
  Reduce a list from the left.
  
  
      iex> import Elmchemy.XList
      iex> foldl.((&cons/0).()).([]).([1, 2, 3])
      [3, 2, 1]
  
  
 
  """
  @spec foldl() :: ((any -> (any -> any)) -> (any -> (list(any) -> any)))
  @spec foldl((any -> (any -> any)), any, list(any)) :: any
  curry foldl/3
  def foldl(func, acc, list) do
    case list do
      [] ->
        acc
      [x | xs] ->
        foldl.(func).(func.(x).(acc)).(xs)
    end
  end

  @doc """
  Reduce a list from the right.
  
  
      iex> import Elmchemy.XList
      iex> foldr.((&+/0).()).(0).([1, 2, 3])
      6
  
  
 
  """
  @spec foldr() :: ((any -> (any -> any)) -> (any -> (list(any) -> any)))
  @spec foldr((any -> (any -> any)), any, list(any)) :: any
  curry foldr/3
  def foldr(f, start, list) do
    foldr_.(list).(start).(f)
  end

  @spec foldr_() :: (list(any) -> (any -> ((any -> (any -> any)) -> any)))
  @spec foldr_(list(any), any, (any -> (any -> any))) :: any
  curryp foldr_/3
  verify as: List.foldr/3
  def foldr_(a1, a2, a3), do: List.foldr(a1, a2, fn (x1,x2) -> a3.(x1).(x2) end)
  @doc """
  Reduce a list from the left, building up all of the intermediate results into a list.
  
  
      iex> import Elmchemy.XList
      iex> scanl.((&+/0).()).(0).([1, 2, 3, 4])
      [0, 1, 3, 6, 10]
  
  
 
  """
  @spec scanl() :: ((any -> (any -> any)) -> (any -> (list(any) -> list(any))))
  @spec scanl((any -> (any -> any)), any, list(any)) :: list(any)
  curry scanl/3
  def scanl(f, b, xs) do
    scan1 = fn(x) -> fn(acc_acc) -> case acc_acc do
      [acc | _] ->
        [f.(x).(acc) | acc_acc]
      [] ->
        []
    end end end
    reverse.(foldl.(scan1).([b]).(xs))
  end

  @doc """
  Keep only elements that satisfy the predicate.
  
  
      iex> import Elmchemy.XList
      iex> filter.(flip.((&rem/0).()).(2) >>> (&==/0).().(0)).([1, 2, 3, 4, 5, 6])
      [2, 4, 6]
  
  
 
  """
  @spec filter() :: ((any -> boolean) -> (list(any) -> list(any)))
  @spec filter((any -> boolean), list(any)) :: list(any)
  curry filter/2
  def filter(pred, xs) do
    conditional_cons = fn(front) -> fn(back) -> if pred.(front) do [front | back] else back end end end
    foldr.(conditional_cons).([]).(xs)
  end

  @doc """
  Apply a function that may succeed to all values in the list, but only keep
  the successes.
  
  
      iex> import Elmchemy.XList
      iex> filter_map.(fn(a) -> if a >= 18 do {a} else nil end end).([3, 15, 12, 18, 24])
      [18, 24]
  
  
 
  """
  @spec filter_map() :: ((any -> {any} | nil) -> (list(any) -> list(any)))
  @spec filter_map((any -> {any} | nil), list(any)) :: list(any)
  curry filter_map/2
  def filter_map(f, xs) do
    foldr.(maybe_cons.(f)).([]).(xs)
  end

  @spec maybe_cons() :: ((any -> {any} | nil) -> (any -> (list(any) -> list(any))))
  @spec maybe_cons((any -> {any} | nil), any, list(any)) :: list(any)
  curryp maybe_cons/3
  defp maybe_cons(f, mx, xs) do
    case f.(mx) do
      {x} ->
        [x | xs]
      nil ->
        xs
    end
  end

  @doc """
  Determine the length of a list.
  
  
      iex> import Elmchemy.XList
      iex> length.([1, 2, 3])
      3
  
  
 
  """
  @spec length() :: (list(any) -> integer)
  @spec length(list(any)) :: integer
  curry length/1
  def length(xs) do
    foldl.(fn(_) -> fn(i) -> i + 1 end end).(0).(xs)
  end

  @doc """
  Reverse a list.
  
  
      iex> import Elmchemy.XList
      iex> reverse.([1, 2, 3, 4])
      [4, 3, 2, 1]
  
  
 
  """
  @spec reverse() :: (list(any) -> list(any))
  @spec reverse(list(any)) :: list(any)
  curry reverse/1
  def reverse(list) do
    foldl.((&cons/0).()).([]).(list)
  end

  @doc """
  Determine if all elements satisfy the predicate.
  
  
      iex> import Elmchemy.XList
      iex> all.(fn(a) -> rem(a, 2) == 0 end).([2, 4])
      :true
  
      iex> import Elmchemy.XList
      iex> all.(fn(a) -> rem(a, 2) == 0 end).([2, 3])
      :false
  
      iex> import Elmchemy.XList
      iex> all.(fn(a) -> rem(a, 2) == 0 end).([])
      :true
  
  
 
  """
  @spec all() :: ((any -> boolean) -> (list(any) -> boolean))
  @spec all((any -> boolean), list(any)) :: boolean
  curry all/2
  def all(is_okay, list) do
    (&!/0).().(any.(is_okay >>> (&!/0).()).(list))
  end

  @doc """
  Determine if any elements satisfy the predicate.
  
  
      iex> import Elmchemy.XList
      iex> any.(fn(a) -> rem(a, 2) == 0 end).([2, 3])
      :true
  
      iex> import Elmchemy.XList
      iex> any.(fn(a) -> rem(a, 2) == 0 end).([1, 3])
      :false
  
      iex> import Elmchemy.XList
      iex> any.(fn(a) -> rem(a, 2) == 0 end).([])
      :false
  
  
 
  """
  @spec any() :: ((any -> boolean) -> (list(any) -> boolean))
  @spec any((any -> boolean), list(any)) :: boolean
  curry any/2
  def any(is_okay, list) do
    case list do
      [] ->
        :false
      [x | xs] ->
        if is_okay.(x) do :true else any.(is_okay).(xs) end
    end
  end

  @doc """
  Put two lists together.
  
  
      iex> import Elmchemy.XList
      iex> append.([1, 1, 2]).([3, 5, 8])
      [1, 1, 2, 3, 5, 8]
  
      iex> import Elmchemy.XList
      iex> append.(['a', 'b']).(['c'])
      ['a', 'b', 'c']
  
  You can also use [the `(++)` operator](Basics#++) to append lists.
  
  
 
  """
  @spec append() :: (list(any) -> (list(any) -> list(any)))
  @spec append(list(any), list(any)) :: list(any)
  curry append/2
  def append(xs, ys) do
    case ys do
      [] ->
        xs
      _ ->
        foldr.((&cons/0).()).(ys).(xs)
    end
  end

  @doc """
  Concatenate a bunch of lists into a single list:
  
  
      iex> import Elmchemy.XList
      iex> concat.([[1, 2], [3], [4, 5]])
      [1, 2, 3, 4, 5]
  
  
 
  """
  @spec concat() :: (list(list(any)) -> list(any))
  @spec concat(list(list(any))) :: list(any)
  curry concat/1
  def concat(lists) do
    foldr.(append).([]).(lists)
  end

  @doc """
  Map a given function onto a list and flatten the resulting lists.
  
  
      iex> import Elmchemy.XList
      iex> concat_map.(range.(2)).([1]) == concat.(map.(range.(2)).([1]))
      true
  
  
 
  """
  @spec concat_map() :: ((any -> list(any)) -> (list(any) -> list(any)))
  @spec concat_map((any -> list(any)), list(any)) :: list(any)
  curry concat_map/2
  def concat_map(f, list) do
    concat.(map.(f).(list))
  end

  @doc """
  Get the sum of the list elements.
  
  
      iex> import Elmchemy.XList
      iex> sum.([1, 2, 3, 4])
      10
  
  
 
  """
  @spec sum() :: (list(number) -> number)
  @spec sum(list(number)) :: number
  curry sum/1
  def sum(numbers) do
    foldl.((&+/0).()).(0).(numbers)
  end

  @doc """
  Get the product of the list elements.
  
  
      iex> import Elmchemy.XList
      iex> product.([1, 2, 3, 4])
      24
  
  
 
  """
  @spec product() :: (list(number) -> number)
  @spec product(list(number)) :: number
  curry product/1
  def product(numbers) do
    foldl.((&*/0).()).(1).(numbers)
  end

  @doc """
  Find the maximum element in a non-empty list.
  
  
      iex> import Elmchemy.XList
      iex> maximum.([1, 4, 2])
      {4}
  
      iex> import Elmchemy.XList
      iex> maximum.([])
      nil
  
  
 
  """
  @spec maximum() :: (list(any) -> {any} | nil)
  @spec maximum(list(any)) :: {any} | nil
  curry maximum/1
  def maximum([x | xs]) do
    {foldl.(max).(x).(xs)}
  end
  def maximum(_) do
    nil
  end

  @doc """
  Find the minimum element in a non-empty list.
  
  
      iex> import Elmchemy.XList
      iex> minimum.([3, 2, 1])
      {1}
  
      iex> import Elmchemy.XList
      iex> minimum.([])
      nil
  
  
 
  """
  @spec minimum() :: (list(any) -> {any} | nil)
  @spec minimum(list(any)) :: {any} | nil
  curry minimum/1
  def minimum([x | xs]) do
    {foldl.(min).(x).(xs)}
  end
  def minimum(_) do
    nil
  end

  @doc """
  Partition a list based on a predicate. The first list contains all values
  that satisfy the predicate, and the second list contains all the value that do
  not.
  
  
      iex> import Elmchemy.XList
      iex> partition.(fn(x) -> x < 3 end).([0, 1, 2, 3, 4, 5])
      {[0, 1, 2], [3, 4, 5]}
  
      iex> import Elmchemy.XList
      iex> partition.(fn(a) -> rem(a, 2) == 0 end).([0, 1, 2, 3, 4, 5])
      {[0, 2, 4], [1, 3, 5]}
  
  
 
  """
  @spec partition() :: ((any -> boolean) -> (list(any) -> {list(any), list(any)}))
  @spec partition((any -> boolean), list(any)) :: {list(any), list(any)}
  curry partition/2
  def partition(pred, list) do
    foldr.(partition_step.(pred)).({[], []}).(list)
  end

  @spec partition_step() :: ((any -> boolean) -> (any -> ({list(any), list(any)} -> {list(any), list(any)})))
  @spec partition_step((any -> boolean), any, {list(any), list(any)}) :: {list(any), list(any)}
  curryp partition_step/3
  defp partition_step(pred, x, {trues, falses}) do
    if pred.(x) do {[x | trues], falses} else {trues, [x | falses]} end
  end

  @doc """
  Combine two lists, combining them with the given function.
  If one list is longer, the extra elements are dropped.
  
  
      iex> import Elmchemy.XList
      iex> map2.((&+/0).()).([1, 2, 3]).([1, 2, 3, 4])
      [2, 4, 6]
  
  
      iex> import Elmchemy.XList
      iex> map2.((&tuple2/0).()).([1, 2, 3]).(['a', 'b'])
      [{1, 'a'}, {2, 'b'}]
  
  
 
  """
  @spec map2() :: ((any -> (any -> any)) -> (list(any) -> (list(any) -> list(any))))
  @spec map2((any -> (any -> any)), list(any), list(any)) :: list(any)
  curry map2/3
  def map2(f, a, b) do
    zip_.(a).(b)
    |> (map.(uncurried.(f))).()
  end

  @spec zip_() :: (list(any) -> (list(any) -> list({any, any})))
  @spec zip_(list(any), list(any)) :: list({any, any})
  curryp zip_/2
  verify as: Enum.zip/2
  def zip_(a1, a2), do: Enum.zip(a1, a2)
  #  {-|-}
  #  map3 : (a -> b -> c -> result) -> List a -> List b -> List c -> List result
  #  map3 =
  #    Native.List.map3
  #  {-|-}
  #  map4 : (a -> b -> c -> d -> result) -> List a -> List b -> List c -> List d -> List result
  #  map4 =
  #    Native.List.map4
  #  {-|-}
  #  map5 : (a -> b -> c -> d -> e -> result) -> List a -> List b -> List c -> List d -> List e -> List result
  #  map5 =
  #    Native.List.map5
  @doc """
  Decompose a list of tuples into a tuple of lists.
  
  
      iex> import Elmchemy.XList
      iex> unzip.(repeat.(3).({0, :true}))
      {[0, 0, 0], [:true, :true, :true]}
  
  
 
  """
  @spec unzip() :: (list({any, any}) -> {list(any), list(any)})
  @spec unzip(list({any, any})) :: {list(any), list(any)}
  curry unzip/1
  def unzip(pairs) do
    foldr.(unzip_step).({[], []}).(pairs)
  end

  @spec unzip_step() :: ({any, any} -> ({list(any), list(any)} -> {list(any), list(any)}))
  @spec unzip_step({any, any}, {list(any), list(any)}) :: {list(any), list(any)}
  curryp unzip_step/2
  defp unzip_step({x, y}, {xs, ys}) do
    {[x | xs], [y | ys]}
  end

  @doc """
  Places the given value between all members of the given list.
  
  
      iex> import Elmchemy.XList
      iex> intersperse.("on").(["turtles", "turtles", "turtles"])
      ["turtles", "on", "turtles", "on", "turtles"]
  
  
 
  """
  @spec intersperse() :: (any -> (list(any) -> list(any)))
  @spec intersperse(any, list(any)) :: list(any)
  curry intersperse/2
  def intersperse(sep, xs) do
    case xs do
      [] ->
        []
      [hd | tl] ->
        step = fn(x) -> fn(rest) -> [sep | [x | rest]] end end
    spersed = foldr.(step).([]).(tl)
    [hd | spersed]
    end
  end

  @doc """
  Take the first *n* members of a list.
  
  
      iex> import Elmchemy.XList
      iex> take.(2).([1, 2, 3, 4])
      [1, 2]
  
  
 
  """
  @spec take() :: (integer -> (list(any) -> list(any)))
  @spec take(integer, list(any)) :: list(any)
  curry take/2
  def take(n, list) do
    take_fast.(0).(n).(list)
  end

  @spec take_fast() :: (integer -> (integer -> (list(any) -> list(any))))
  @spec take_fast(integer, integer, list(any)) :: list(any)
  curryp take_fast/3
  defp take_fast(ctr, n, list) do
    if n <= 0 do [] else case {n, list} do
      {_, []} ->
        list
      {1, [x | _]} ->
        [x]
      {2, [x | [y | _]]} ->
        [x, y]
      {3, [x | [y | [z | _]]]} ->
        [x, y, z]
      {_, [x | [y | [z | [w | tl]]]]} ->
        if ctr > 1000 do [x | [y | [z | [w | take_tail_rec.(n - 4).(tl)]]]] else [x | [y | [z | [w | take_fast.(ctr + 1).(n - 4).(tl)]]]] end
      _ ->
        list
    end end
  end

  @spec take_tail_rec() :: (integer -> (list(any) -> list(any)))
  @spec take_tail_rec(integer, list(any)) :: list(any)
  curryp take_tail_rec/2
  defp take_tail_rec(n, list) do
    reverse.(take_reverse.(n).(list).([]))
  end

  @spec take_reverse() :: (integer -> (list(any) -> (list(any) -> list(any))))
  @spec take_reverse(integer, list(any), list(any)) :: list(any)
  curryp take_reverse/3
  defp take_reverse(n, list, taken) do
    if n <= 0 do taken else case list do
      [] ->
        taken
      [x | xs] ->
        take_reverse.(n - 1).(xs).([x | taken])
    end end
  end

  @doc """
  Drop the first *n* members of a list.
  
  
      iex> import Elmchemy.XList
      iex> drop.(2).([1, 2, 3, 4])
      [3, 4]
  
  
 
  """
  @spec drop() :: (integer -> (list(any) -> list(any)))
  @spec drop(integer, list(any)) :: list(any)
  curry drop/2
  def drop(n, list) do
    if n <= 0 do list else case list do
      [] ->
        list
      [x | xs] ->
        drop.(n - 1).(xs)
    end end
  end

  @doc """
  Create a list with only one element:
  
  
      iex> import Elmchemy.XList
      iex> singleton.(1234)
      [1234]
  
      iex> import Elmchemy.XList
      iex> singleton.("hi")
      ["hi"]
  
  
 
  """
  @spec singleton() :: (any -> list(any))
  @spec singleton(any) :: list(any)
  curry singleton/1
  def singleton(value) do
    [value]
  end

  @doc """
  Create a list with *n* copies of a value:
  
  
      iex> import Elmchemy.XList
      iex> repeat.(3).(0)
      [0, 0, 0]
  
  
 
  """
  @spec repeat() :: (integer -> (any -> list(any)))
  @spec repeat(integer, any) :: list(any)
  curry repeat/2
  def repeat(n, value) do
    repeat_help.([]).(n).(value)
  end

  @spec repeat_help() :: (list(any) -> (integer -> (any -> list(any))))
  @spec repeat_help(list(any), integer, any) :: list(any)
  curryp repeat_help/3
  defp repeat_help(result, n, value) do
    if n <= 0 do result else repeat_help.([value | result]).(n - 1).(value) end
  end

  @doc """
  Create a list of numbers, every element increasing by one.
  You give the lowest and highest number that should be in the list.
  
  
      iex> import Elmchemy.XList
      iex> range.(3).(6)
      [3, 4, 5, 6]
  
      iex> import Elmchemy.XList
      iex> range.(3).(3)
      [3]
  
      iex> import Elmchemy.XList
      iex> range.(6).(3)
      []
  
  
 
  """
  @spec range() :: (integer -> (integer -> list(integer)))
  @spec range(integer, integer) :: list(integer)
  curry range/2
  def range(lo, hi) do
    range_help.(lo).(hi).([])
  end

  @spec range_help() :: (integer -> (integer -> (list(integer) -> list(integer))))
  @spec range_help(integer, integer, list(integer)) :: list(integer)
  curryp range_help/3
  defp range_help(lo, hi, list) do
    if lo <= hi do range_help.(lo).(hi - 1).([hi | list]) else list end
  end

  @doc """
  Sort values from lowest to highest
  
  
      iex> import Elmchemy.XList
      iex> sort.([3, 1, 5])
      [1, 3, 5]
  
  
 
  """
  @spec sort() :: (list(any) -> list(any))
  @spec sort(list(any)) :: list(any)
  curry sort/1
  def sort(xs) do
    sort_by.(identity).(xs)
  end

  @doc """
  Sort values by a derived property. To be replaced
  
  
      iex> import Elmchemy.XList
      iex> sort_by.(fn({i, a}) -> i end).([{1, "mouse"}, {0, "cat"}])
      [{0, "cat"}, {1, "mouse"}]
  
  
 
  """
  @spec sort_by() :: ((any -> any) -> (list(any) -> list(any)))
  @spec sort_by((any -> any), list(any)) :: list(any)
  curry sort_by/2
  def sort_by(f, list) do
    sort_with.(fn(a) -> fn(b) -> compare.(f.(a)).(f.(b)) end end).(list)
  end

  @doc """
  Sort values with a custom comparison function.
  
  
      iex> import Elmchemy.XList
      iex> sort_with.(flip.(compare)).([1, 2, 3, 4, 5])
      [5, 4, 3, 2, 1]
  
  This is also the most general sort function, allowing you
  to define any other: `sort == sortWith compare`
  f
  
  
 
  """
  @spec sort_with() :: ((any -> (any -> Elmchemy.XBasics.order)) -> (list(any) -> list(any)))
  @spec sort_with((any -> (any -> Elmchemy.XBasics.order)), list(any)) :: list(any)
  curry sort_with/2
  def sort_with(f, list) do
    exf = fn(a) -> fn(b) -> f.(a).(b)
    |> (fn(a) -> case a do
      :gt ->
        :false
      :eq ->
        :false
      :lt ->
        :true
    end end).() end end
    sort_.(list).(exf)
  end

  @spec sort_() :: (list(any) -> ((any -> (any -> boolean)) -> list(any)))
  @spec sort_(list(any), (any -> (any -> boolean))) :: list(any)
  curryp sort_/2
  verify as: Enum.sort/2
  def sort_(a1, a2), do: Enum.sort(a1, fn (x1,x2) -> a2.(x1).(x2) end)
end
