
# Compiled using Elmchemy v0.3.33
defmodule Elmchemy.XDict do
  use Elmchemy

  @doc """
  A dictionary mapping unique keys to values. The keys can be any comparable
  type. This includes `Int`, `Float`, `Time`, `Char`, `String`, and tuples or
  lists of comparable types.
  
  Insert, remove, and query operations all take *O(log n)* time.
  
  
  # Dictionaries
  
  @docs Dict
  
  
  # Build
  
  @docs empty, singleton, insert, update, remove
  
  
  # Query
  
  @docs isEmpty, member, get, size
  
  
  # Lists
  
  @docs keys, values, toList, fromList
  
  
  # Transform
  
  @docs map, foldl, foldr, filter, partition
  
  
  # Combine
  
  @docs union, intersect, diff, merge
  
  
 
  """
  import XBasics
  import XMaybe
  import XList
  alias XString
  @type n_color :: :red | :black | :b_black | :n_black

  @type leaf_color :: :l_black | :l_b_black

  @doc """
  A dictionary of keys and values. So a `(Dict String User)` is a dictionary
  that lets you look up a `String` (such as user names) and find the associated
  `User`.
  
 
  """
  @type dict :: {:r_b_node_elm_builtin, n_color, any, any, dict, dict} | {:r_b_empty_elm_builtin, leaf_color}

  @doc """
  Create an empty dictionary.
  
 
  """
  @spec empty() :: dict
  def empty() do
    {:r_b_empty_elm_builtin, :l_black}
  end

  @spec max_with_default(any, any, dict) :: {any, any}
  curryp max_with_default/3
  defp max_with_default(k, v, r) do
    case r do
      {:r_b_empty_elm_builtin, _} ->
        {k, v}
      {:r_b_node_elm_builtin, _, kr, vr, _, rr} ->
        max_with_default.(kr).(vr).(rr)
    end
  end

  @doc """
  Get the value associated with a key. If the key is not found, return
  `Nothing`. This is useful when you are not sure if a key will be in the
  dictionary.
  
      animals = fromList [ ("Tom", Cat), ("Jerry", Mouse) ]
  
  
      iex> import Elmchemy.XDict
      iex> get.("Tom").(animals)
      {:cat}
  
      iex> import Elmchemy.XDict
      iex> get.("Jerry").(animals)
      {:mouse}
  
      iex> import Elmchemy.XDict
      iex> get.("Spike").(animals)
      nil
  
  
 
  """
  @spec get(any, dict) :: {any} | nil
  curry get/2
  def get(target_key, dict) do
    case dict do
      {:r_b_empty_elm_builtin, _} ->
        nil
      {:r_b_node_elm_builtin, _, key, value, left, right} ->
        case compare.(target_key).(key) do
      :lt ->
        get.(target_key).(left)
      :eq ->
        {value}
      :gt ->
        get.(target_key).(right)
    end
    end
  end

  @doc """
  Determine if a key is in a dictionary.
  
 
  """
  @spec member(any, dict) :: boolean
  curry member/2
  def member(key, dict) do
    case get.(key).(dict) do
      {_} ->
        :true
      nil ->
        :false
    end
  end

  @doc """
  Determine the number of key-value pairs in the dictionary.
  
 
  """
  @spec size(dict) :: integer
  curry size/1
  def size(dict) do
    size_help.(0).(dict)
  end

  @spec size_help(integer, dict) :: integer
  curryp size_help/2
  defp size_help(n, dict) do
    case dict do
      {:r_b_empty_elm_builtin, _} ->
        n
      {:r_b_node_elm_builtin, _, _, _, left, right} ->
        size_help.(size_help.(( n + 1 )).(right)).(left)
    end
  end

  @doc """
  Determine if a dictionary is empty.
  
  
      iex> import Elmchemy.XDict
      iex> is_empty.(empty)
      :true
  
  
 
  """
  @spec is_empty(dict) :: boolean
  curry is_empty/1
  def is_empty(dict) do
    ( dict == empty )
  end

  #  The actual pattern match here is somewhat lax. If it is given invalid input,
  #    it will do the wrong thing. The expected behavior is:

  #      red node => black node
  #      black node => same
  #      bblack node => xxx
  #      nblack node => xxx

  #      black leaf => same
  #      bblack leaf => xxx

  @spec ensure_black_root(dict) :: dict
  curryp ensure_black_root/1
  defp ensure_black_root({:r_b_node_elm_builtin, :red, key, value, left, right}) do
    {:r_b_node_elm_builtin, :black, key, value, left, right}
  end
  defp ensure_black_root(_) do
    dict
  end

  @doc """
  Insert a key-value pair into a dictionary. Replaces value when there is
  a collision.
  
 
  """
  @spec insert(any, any, dict) :: dict
  curry insert/3
  def insert(key, value, dict) do
    update.(key).(always.({value})).(dict)
  end

  @doc """
  Remove a key-value pair from a dictionary. If the key is not found,
  no changes are made.
  
 
  """
  @spec remove(any, dict) :: dict
  curry remove/2
  def remove(key, dict) do
    update.(key).(always.(nil)).(dict)
  end

  @type flag :: :insert | :remove | :same

  @doc """
  Update the value of a dictionary for a specific key with a given function.
  
 
  """
  @spec update(any, ({any} | nil -> {any} | nil), dict) :: dict
  curry update/3
  def update(k, alter, dict) do
    up = fn(dict) -> case dict do
      {:r_b_empty_elm_builtin, _} ->
        case alter.(nil) do
      nil ->
        {:same, empty}
      {v} ->
        {:insert, {:r_b_node_elm_builtin, :red, k, v, empty, empty}}
      {:r_b_node_elm_builtin, clr, key, value, left, right} ->
        case compare.(k).(key) do
      :eq ->
        case alter.({value}) do
      nil ->
        {:remove, rem.(clr).(left).(right)}
      {new_value} ->
        {:same, {:r_b_node_elm_builtin, clr, key, new_value, left, right}}
      :lt ->
        {flag, new_left} = up.(left)
    case flag do
      :same ->
        {:same, {:r_b_node_elm_builtin, clr, key, value, new_left, right}}
      :insert ->
        {:insert, balance.(clr).(key).(value).(new_left).(right)}
      :remove ->
        {:remove, bubble.(clr).(key).(value).(new_left).(right)}
      :gt ->
        {flag, new_right} = up.(right)
    case flag do
      :same ->
        {:same, {:r_b_node_elm_builtin, clr, key, value, left, new_right}}
      :insert ->
        {:insert, balance.(clr).(key).(value).(left).(new_right)}
      :remove ->
        {:remove, bubble.(clr).(key).(value).(left).(new_right)}
    end
    end
    end
    end
    end
    end end
    {flag, updated_dict} = up.(dict)
    case flag do
      :same ->
        updated_dict
      :insert ->
        ensure_black_root.(updated_dict)
      :remove ->
        blacken.(updated_dict)
    end
  end

  @doc """
  Create a dictionary with one key-value pair.
  
 
  """
  @spec singleton(any, any) :: dict
  curry singleton/2
  def singleton(key, value) do
    insert.(key).(value).(empty)
  end

  @spec is_b_black(dict) :: boolean
  curryp is_b_black/1
  defp is_b_black({:r_b_node_elm_builtin, :b_black, _, _, _, _}) do
    :true
  end
  defp is_b_black({:r_b_empty_elm_builtin, :l_b_black}) do
    :true
  end
  defp is_b_black(_) do
    :false
  end

  @spec more_black(n_color) :: n_color
  curryp more_black/1
  defp more_black(:black) do
    :b_black
  end
  defp more_black(:red) do
    :black
  end
  defp more_black(:n_black) do
    :red
  end
  defp more_black(:b_black) do
    Native.XDebug.crash.("Can't make a double black node more black!")
  end

  @spec less_black(n_color) :: n_color
  curryp less_black/1
  defp less_black(:b_black) do
    :black
  end
  defp less_black(:black) do
    :red
  end
  defp less_black(:red) do
    :n_black
  end
  defp less_black(:n_black) do
    Native.XDebug.crash.("Can't make a negative black node less black!")
  end

  #  The actual pattern match here is somewhat lax. If it is given invalid input,
  #    it will do the wrong thing. The expected behavior is:

  #      node => less black node

  #      bblack leaf => black leaf
  #      black leaf => xxx

  @spec less_black_tree(dict) :: dict
  curryp less_black_tree/1
  defp less_black_tree({:r_b_node_elm_builtin, c, k, v, l, r}) do
    {:r_b_node_elm_builtin, less_black.(c), k, v, l, r}
  end
  defp less_black_tree({:r_b_empty_elm_builtin, _}) do
    {:r_b_empty_elm_builtin, :l_black}
  end

  @spec report_rem_bug(String.t, n_color, String.t, String.t) :: any
  curryp report_rem_bug/4
  defp report_rem_bug(msg, c, lgot, rgot) do
    XString.concat.(["Internal red-black tree invariant violated, expected ", msg, " and got ", to_string.(c), "/", lgot, "/", rgot, "\nPlease report this bug to <https://github.com/elm-lang/core/issues>"])
    |> (Native.XDebug.crash).()
  end

  @spec rem(n_color, dict, dict) :: dict
  curryp rem/3
  defp rem(color, left, right) do
    case {left, right} do
      {{:r_b_empty_elm_builtin, _}, {:r_b_empty_elm_builtin, _}} ->
        case color do
      :red ->
        {:r_b_empty_elm_builtin, :l_black}
      :black ->
        {:r_b_empty_elm_builtin, :l_b_black}
      _ ->
        Native.XDebug.crash.("cannot have bblack or nblack nodes at this point")
      {{:r_b_empty_elm_builtin, cl}, {:r_b_node_elm_builtin, cr, k, v, l, r}} ->
        case {color, cl, cr} do
      {:black, :l_black, :red} ->
        {:r_b_node_elm_builtin, :black, k, v, l, r}
      _ ->
        report_rem_bug.("Black/LBlack/Red").(color).(to_string.(cl)).(to_string.(cr))
      {{:r_b_node_elm_builtin, cl, k, v, l, r}, {:r_b_empty_elm_builtin, cr}} ->
        case {color, cl, cr} do
      {:black, :red, :l_black} ->
        {:r_b_node_elm_builtin, :black, k, v, l, r}
      _ ->
        report_rem_bug.("Black/Red/LBlack").(color).(to_string.(cl)).(to_string.(cr))
      {{:r_b_node_elm_builtin, cl, kl, vl, ll, rl}, {:r_b_node_elm_builtin, _, _, _, _, _}} ->
        {k, v} = max_with_default.(kl).(vl).(rl)
    new_left = remove_max.(cl).(kl).(vl).(ll).(rl)
    bubble.(color).(k).(v).(new_left).(right)
    end
    end
    end
    end
  end

  @spec bubble(n_color, any, any, dict, dict) :: dict
  curryp bubble/5
  defp bubble(c, k, v, l, r) do
    if ( is_b_black.(l) || is_b_black.(r) ) do balance.(more_black.(c)).(k).(v).(less_black_tree.(l)).(less_black_tree.(r)) else {:r_b_node_elm_builtin, c, k, v, l, r} end
  end

  @spec remove_max(n_color, any, any, dict, dict) :: dict
  curryp remove_max/5
  defp remove_max(c, k, v, l, r) do
    case r do
      {:r_b_empty_elm_builtin, _} ->
        rem.(c).(l).(r)
      {:r_b_node_elm_builtin, cr, kr, vr, lr, rr} ->
        bubble.(c).(k).(v).(l).(remove_max.(cr).(kr).(vr).(lr).(rr))
    end
  end

  @spec balance(n_color, any, any, dict, dict) :: dict
  curryp balance/5
  defp balance(c, k, v, l, r) do
    tree = {:r_b_node_elm_builtin, c, k, v, l, r}
    if blackish.(tree) do balance_help.(tree) else tree end
  end

  @spec blackish(dict) :: boolean
  curryp blackish/1
  defp blackish({:r_b_node_elm_builtin, c, _, _, _, _}) do
    ( ( c == :black ) || ( c == :b_black ) )
  end
  defp blackish({:r_b_empty_elm_builtin, _}) do
    :true
  end

  @spec balance_help(dict) :: dict
  curryp balance_help/1
  defp balance_help({:r_b_node_elm_builtin, col, zk, zv, {:r_b_node_elm_builtin, :red, yk, yv, {:r_b_node_elm_builtin, :red, xk, xv, a, b}, c}, d}) do
    balanced_tree.(col).(xk).(xv).(yk).(yv).(zk).(zv).(a).(b).(c).(d)
  end
  defp balance_help({:r_b_node_elm_builtin, col, zk, zv, {:r_b_node_elm_builtin, :red, xk, xv, a, {:r_b_node_elm_builtin, :red, yk, yv, b, c}}, d}) do
    balanced_tree.(col).(xk).(xv).(yk).(yv).(zk).(zv).(a).(b).(c).(d)
  end
  defp balance_help({:r_b_node_elm_builtin, col, xk, xv, a, {:r_b_node_elm_builtin, :red, zk, zv, {:r_b_node_elm_builtin, :red, yk, yv, b, c}, d}}) do
    balanced_tree.(col).(xk).(xv).(yk).(yv).(zk).(zv).(a).(b).(c).(d)
  end
  defp balance_help({:r_b_node_elm_builtin, col, xk, xv, a, {:r_b_node_elm_builtin, :red, yk, yv, b, {:r_b_node_elm_builtin, :red, zk, zv, c, d}}}) do
    balanced_tree.(col).(xk).(xv).(yk).(yv).(zk).(zv).(a).(b).(c).(d)
  end
  defp balance_help({:r_b_node_elm_builtin, :b_black, xk, xv, a, {:r_b_node_elm_builtin, :n_black, zk, zv, {:r_b_node_elm_builtin, :black, yk, yv, b, c}, ( {:r_b_node_elm_builtin, :black, _, _, _, _} = d )}}) do
    {:r_b_node_elm_builtin, :black, yk, yv, {:r_b_node_elm_builtin, :black, xk, xv, a, b}, balance.(:black).(zk).(zv).(c).(redden.(d))}
  end
  defp balance_help({:r_b_node_elm_builtin, :b_black, zk, zv, {:r_b_node_elm_builtin, :n_black, xk, xv, ( {:r_b_node_elm_builtin, :black, _, _, _, _} = a ), {:r_b_node_elm_builtin, :black, yk, yv, b, c}}, d}) do
    {:r_b_node_elm_builtin, :black, yk, yv, balance.(:black).(xk).(xv).(redden.(a)).(b), {:r_b_node_elm_builtin, :black, zk, zv, c, d}}
  end
  defp balance_help(_) do
    tree
  end

  @spec balanced_tree(n_color, any, any, any, any, any, any, dict, dict, dict, dict) :: dict
  curryp balanced_tree/11
  defp balanced_tree(col, xk, xv, yk, yv, zk, zv, a, b, c, d) do
    {:r_b_node_elm_builtin, less_black.(col), yk, yv, {:r_b_node_elm_builtin, :black, xk, xv, a, b}, {:r_b_node_elm_builtin, :black, zk, zv, c, d}}
  end

  @spec blacken(dict) :: dict
  curryp blacken/1
  defp blacken({:r_b_empty_elm_builtin, _}) do
    {:r_b_empty_elm_builtin, :l_black}
  end
  defp blacken({:r_b_node_elm_builtin, _, k, v, l, r}) do
    {:r_b_node_elm_builtin, :black, k, v, l, r}
  end

  @spec redden(dict) :: dict
  curryp redden/1
  defp redden({:r_b_empty_elm_builtin, _}) do
    Native.XDebug.crash.("can't make a Leaf red")
  end
  defp redden({:r_b_node_elm_builtin, _, k, v, l, r}) do
    {:r_b_node_elm_builtin, :red, k, v, l, r}
  end

  @doc """
  Combine two dictionaries. If there is a collision, preference is given
  to the first dictionary.
  
 
  """
  @spec union(dict, dict) :: dict
  curry union/2
  def union(t1, t2) do
    foldl.(insert).(t2).(t1)
  end

  @doc """
  Keep a key-value pair when its key appears in the second dictionary.
  Preference is given to values in the first dictionary.
  
 
  """
  @spec intersect(dict, dict) :: dict
  curry intersect/2
  def intersect(t1, t2) do
    filter.(fn(k) -> fn(_) -> member.(k).(t2) end end).(t1)
  end

  @doc """
  Keep a key-value pair when its key does not appear in the second dictionary.
  
 
  """
  @spec diff(dict, dict) :: dict
  curry diff/2
  def diff(t1, t2) do
    foldl.(fn(k) -> fn(v) -> fn(t) -> remove.(k).(t) end end end).(t1).(t2)
  end

  @doc """
  The most general way of combining two dictionaries. You provide three
  accumulators for when a given key appears:
  
  1.  Only in the left dictionary.
  2.  In both dictionaries.
  3.  Only in the right dictionary.
  
  You then traverse all the keys from lowest to highest, building up whatever
  you want.
  
  
 
  """
  @spec merge((any -> (any -> (any -> any))), (any -> (any -> (any -> (any -> any)))), (any -> (any -> (any -> any))), dict, dict, any) :: any
  curry merge/6
  def merge(left_step, both_step, right_step, left_dict, right_dict, initial_result) do
    step_state = fn(r_key) -> fn(r_value) -> fn({list, result}) -> case list do
      [] ->
        {list, right_step.(r_key).(r_value).(result)}
      [{l_key, l_value} | rest] ->
        cond do
      ( l_key < r_key ) -> step_state.(r_key).(r_value).({rest, left_step.(l_key).(l_value).(result)})
      ( l_key > r_key ) -> {list, right_step.(r_key).(r_value).(result)}
      true -> {rest, both_step.(l_key).(l_value).(r_value).(result)}
    end
    end end end end
    {leftovers, intermediate_result} = foldl.(step_state).({to_list.(left_dict), initial_result}).(right_dict)
    XList.foldl.(fn({k, v}) -> fn(result) -> left_step.(k).(v).(result) end end).(intermediate_result).(leftovers)
  end

  @doc """
  Apply a function to all values in a dictionary.
  
 
  """
  @spec map((any -> (any -> any)), dict) :: dict
  curry map/2
  def map(f, dict) do
    case dict do
      {:r_b_empty_elm_builtin, _} ->
        {:r_b_empty_elm_builtin, :l_black}
      {:r_b_node_elm_builtin, clr, key, value, left, right} ->
        {:r_b_node_elm_builtin, clr, key, f.(key).(value), map.(f).(left), map.(f).(right)}
    end
  end

  @doc """
  Fold over the key-value pairs in a dictionary, in order from lowest
  key to highest key.
  
 
  """
  @spec foldl((any -> (any -> (any -> any))), any, dict) :: any
  curry foldl/3
  def foldl(f, acc, dict) do
    case dict do
      {:r_b_empty_elm_builtin, _} ->
        acc
      {:r_b_node_elm_builtin, _, key, value, left, right} ->
        foldl.(f).(f.(key).(value).(foldl.(f).(acc).(left))).(right)
    end
  end

  @doc """
  Fold over the key-value pairs in a dictionary, in order from highest
  key to lowest key.
  
 
  """
  @spec foldr((any -> (any -> (any -> any))), any, dict) :: any
  curry foldr/3
  def foldr(f, acc, t) do
    case t do
      {:r_b_empty_elm_builtin, _} ->
        acc
      {:r_b_node_elm_builtin, _, key, value, left, right} ->
        foldr.(f).(f.(key).(value).(foldr.(f).(acc).(right))).(left)
    end
  end

  @doc """
  Keep a key-value pair when it satisfies a predicate.
  
 
  """
  @spec filter((any -> (any -> boolean)), dict) :: dict
  curry filter/2
  def filter(predicate, dictionary) do
    add = fn(key) -> fn(value) -> fn(dict) -> if predicate.(key).(value) do insert.(key).(value).(dict) else dict end end end end
    foldl.(add).(empty).(dictionary)
  end

  @doc """
  Partition a dictionary according to a predicate. The first dictionary
  contains all key-value pairs which satisfy the predicate, and the second
  contains the rest.
  
 
  """
  @spec partition((any -> (any -> boolean)), dict) :: {dict, dict}
  curry partition/2
  def partition(predicate, dict) do
    add = fn(key) -> fn(value) -> fn({t1, t2}) -> if predicate.(key).(value) do {insert.(key).(value).(t1), t2} else {t1, insert.(key).(value).(t2)} end end end end
    foldl.(add).({empty, empty}).(dict)
  end

  @doc """
  Get all of the keys in a dictionary, sorted from lowest to highest.
  
  
      iex> import Elmchemy.XDict
      iex> keys.(from_list.([{0, "Alice"}, {1, "Bob"}]))
      [0, 1]
  
  
 
  """
  @spec keys(dict) :: list(any)
  curry keys/1
  def keys(dict) do
    foldr.(fn(key) -> fn(value) -> fn(key_list) -> [key | key_list] end end end).([]).(dict)
  end

  @doc """
  Get all of the values in a dictionary, in the order of their keys.
  
  
      iex> import Elmchemy.XDict
      iex> values.(from_list.([{0, "Alice"}, {1, "Bob"}]))
      ["Alice", "Bob"]
  
  
 
  """
  @spec values(dict) :: list(any)
  curry values/1
  def values(dict) do
    foldr.(fn(key) -> fn(value) -> fn(value_list) -> [value | value_list] end end end).([]).(dict)
  end

  @doc """
  Convert a dictionary into an association list of key-value pairs, sorted by keys.
  
 
  """
  @spec to_list(dict) :: list({any, any})
  curry to_list/1
  def to_list(dict) do
    foldr.(fn(key) -> fn(value) -> fn(list) -> [{key, value} | list] end end end).([]).(dict)
  end

  @doc """
  Convert an association list into a dictionary.
  
 
  """
  @spec from_list(list({any, any})) :: dict
  curry from_list/1
  def from_list(assocs) do
    XList.foldl.(fn({key, value}) -> fn(dict) -> insert.(key).(value).(dict) end end).(empty).(assocs)
  end

end
