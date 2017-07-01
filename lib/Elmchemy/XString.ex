
# Compiled using Elmchemy v0.3.33
defmodule Elmchemy.XString do
  use Elmchemy

  @doc """
  A built-in representation for efficient string manipulation. String literals
  are enclosed in `"double quotes"`. Strings are *not* lists of characters.
  
  
  # Basics
  
  @docs isEmpty, length, reverse, repeat
  
  
  # Building and Splitting
  
  @docs cons, uncons, fromChar, append, concat, split, join, words, lines
  
  
  # Get Substrings
  
  @docs slice, left, right, dropLeft, dropRight
  
  
  # Check for Substrings
  
  @docs contains, startsWith, endsWith, indexes, indices
  
  
  # Conversions
  
  @docs toInt, toFloat, toList, fromList
  
  
  # Formatting
  
  Cosmetic operations such as padding with extra characters or trimming whitespace.
  
  @docs toUpper, toLower, pad, padLeft, padRight, trim, trimLeft, trimRight
  
  
  # Higher-Order Functions
  
  @docs map, filter, foldl, foldr, any, all
  
  
 
  """
  import Elmchemy
  alias Elmchemy.XResult, as: XResult
  alias Elmchemy.XList, as: XList
  alias Elmchemy.XTuple, as: XTuple

  import Kernel, except: [
  {:length, 1},
  {:'++', 2},
  {:to_charlist, 1}

  ]
  import Elmchemy.XBasics, except: [
  {:to_float, 1},
  ]

  @doc """
  Determine if a string is empty.
  
  
      iex> import Elmchemy.XString
      iex> is_empty.("")
      :true
  
      iex> import Elmchemy.XString
      iex> is_empty.("the world")
      :false
  
  
 
  """
  @spec is_empty(String.t) :: boolean
  curry is_empty/1
  def is_empty(str) do
    ( length.(str) == 0 )
  end

  @doc """
  Add a character to the beginning of a string.
  
  
      iex> import Elmchemy.XString
      iex> XString.cons.('T').("he truth is out there")
      "The truth is out there"
  
  
 
  """
  @spec cons(char_list, String.t) :: String.t
  curry cons/2
  def cons(c, str) do
    ( from_char.(c) ++ str )
  end

  @doc """
  Create a string from a given character.
  
  
      iex> import Elmchemy.XString
      iex> from_char.('a')
      "a"
  
  
 
  """
  @spec from_char(char_list) :: String.t
  curry from_char/1
  verify as: :binary.list_to_bin/1
  def from_char(a1), do: :binary.list_to_bin(a1)
  @doc """
  Split a non-empty string into its head and tail. This lets you
  pattern match on strings exactly as you would with lists.
  
  
      iex> import Elmchemy.XString
      iex> uncons.("abc")
      {{'a', "bc"}}
  
      iex> import Elmchemy.XString
      iex> uncons.("")
      nil
  
  
 
  """
  @spec uncons(String.t) :: {{char_list, String.t}} | nil
  curry uncons/1
  def uncons(str) do
    {first, rest} = split_at_.(str).(1)
    real_first = first
    |> (to_list).()
    case real_first do
      [] ->
        nil
      [r] ->
        {{r, rest}}
      _ ->
        nil
    end
  end

  @spec split_at_(String.t, integer) :: {String.t, String.t}
  curryp split_at_/2
  verify as: String.split_at/2
  def split_at_(a1, a2), do: String.split_at(a1, a2)
  @doc """
  Append two strings. You can also use [the `(++)` operator](Basics#++)
  to do this.
  
  
      iex> import Elmchemy.XString
      iex> append.("butter").("fly")
      "butterfly"
  
  
 
  """
  @spec append(String.t, String.t) :: String.t
  curry append/2
  def append(a, b) do
    ( a ++ b )
  end

  @doc """
  Concatenate many strings into one.
  
  
      iex> import Elmchemy.XString
      iex> concat.(["never", "the", "less"])
      "nevertheless"
  
  
 
  """
  @spec concat(list(String.t)) :: String.t
  curry concat/1
  def concat(list) do
    XList.foldr.((&++/0).()).("").(list)
  end

  @doc """
  Get the length of a string.
  
  
      iex> import Elmchemy.XString
      iex> length.("innumerable")
      11
  
      iex> import Elmchemy.XString
      iex> length.("")
      0
  
  
 
  """
  @spec length(String.t) :: integer
  curry length/1
  verify as: String.length/1
  def length(a1), do: String.length(a1)
  @doc """
  Transform every character in a string
  
  
      iex> import Elmchemy.XString
      iex> map.(fn(c) -> if ( c == '/' ) do '.' else c end end).("a/b/c")
      "a.b.c"
  
  
 
  """
  curry map/2
  def map(f, str) do
    str
    |> (to_list).()
    |> (fn(str) -> XList.map.(f).(str) end).()
    |> (XList.map.(from_char)).()
    |> (join.("")).()
  end

  @doc """
  Keep only the characters that satisfy the predicate.
  
  
      iex> import Elmchemy.XString
      iex> filter.((&==/0).().('2')).("R2-D2")
      "22"
  
  
 
  """
  curry filter/2
  def filter(f, str) do
    str
    |> (to_list).()
    |> (fn(str) -> XList.filter.(f).(str) end).()
    |> (XList.map.(from_char)).()
    |> (join.("")).()
  end

  @doc """
  Reverse a string.
  
  
      iex> import Elmchemy.XString
      iex> reverse.("stressed")
      "desserts"
  
  
 
  """
  @spec reverse(String.t) :: String.t
  curry reverse/1
  verify as: String.reverse/1
  def reverse(a1), do: String.reverse(a1)
  @doc """
  Reduce a string from the left.
  
  
      iex> import Elmchemy.XString
      iex> foldl.(XString.cons).("").("time")
      "emit"
  
  
 
  """
  curry foldl/3
  def foldl(f, acc, str) do
    str
    |> (to_list).()
    |> (XList.foldl.(f).(acc)).()
  end

  @doc """
  Reduce a string from the right.
  
  
      iex> import Elmchemy.XString
      iex> foldr.(XString.cons).("").("time")
      "time"
  
  
 
  """
  curry foldr/3
  def foldr(f, acc, str) do
    str
    |> (to_list).()
    |> (XList.foldr.(f).(acc)).()
  end

  @doc """
  Split a string using a given separator.
  
  
      iex> import Elmchemy.XString
      iex> split.(",").("cat,dog,cow")
      ["cat", "dog", "cow"]
  
      iex> import Elmchemy.XString
      iex> split.("/").("home/evan/Desktop/")
      ["home", "evan", "Desktop", ""]
  
  Use [`Regex.split`](Regex#split) if you need something more flexible.
  
  
 
  """
  @spec split(String.t, String.t) :: list(String.t)
  curry split/2
  def split(pattern, str) do
    split_.(str).([pattern]).([])
  end

  @type split_option :: {:trim, boolean}

  @spec split_(String.t, list(String.t), list(split_option)) :: list(String.t)
  curryp split_/3
  verify as: String.split/3
  def split_(a1, a2, a3), do: String.split(a1, a2, a3)
  @doc """
  Put many strings together with a given separator.
  
  
      iex> import Elmchemy.XString
      iex> join.("a").(["H", "w", "ii", "n"])
      "Hawaiian"
  
      iex> import Elmchemy.XString
      iex> join.(" ").(["cat", "dog", "cow"])
      "cat dog cow"
  
      iex> import Elmchemy.XString
      iex> join.("/").(["home", "evan", "Desktop"])
      "home/evan/Desktop"
  
  
 
  """
  @spec join(String.t, list(String.t)) :: String.t
  curry join/2
  def join(str, list) do
    join_.(list).(str)
  end

  @spec join_(list(String.t), String.t) :: String.t
  curryp join_/2
  verify as: Enum.join/2
  def join_(a1, a2), do: Enum.join(a1, a2)
  @doc """
  Repeat a string *n* times.
  
  
      iex> import Elmchemy.XString
      iex> repeat.(3).("ha")
      "hahaha"
  
  
 
  """
  @spec repeat(integer, String.t) :: String.t
  curry repeat/2
  def repeat(n, str) do
    repeat_.(str).(n)
  end

  @spec repeat_(String.t, integer) :: String.t
  curryp repeat_/2
  verify as: String.duplicate/2
  def repeat_(a1, a2), do: String.duplicate(a1, a2)
  @doc """
  Take a substring given a start and end index. Negative indexes
  are taken starting from the *end* of the list.
  
  
      iex> import Elmchemy.XString
      iex> slice.(7).(9).("snakes on a plane!")
      "on"
  
      iex> import Elmchemy.XString
      iex> slice.(0).(6).("snakes on a plane!")
      "snakes"
  
      iex> import Elmchemy.XString
      iex> slice.(0).(-7).("snakes on a plane!")
      "snakes on a"
  
      iex> import Elmchemy.XString
      iex> slice.(-6).(-1).("snakes on a plane!")
      "plane"
  
  
 
  """
  @spec slice(integer, integer, String.t) :: String.t
  curry slice/3
  def slice(from, to, str) do
    l = length.(str)
    mirror = fn(a) -> if ( a < 0 ) do ( l + a ) else a end end
    start = mirror.(from)
    len = ( mirror.(to) - start )
    slice_.(str).(start).(len)
  end

  @spec slice_(String.t, integer, integer) :: String.t
  curryp slice_/3
  verify as: String.slice/3
  def slice_(a1, a2, a3), do: String.slice(a1, a2, a3)
  @doc """
  Take *n* characters from the left side of a string.
  
  
      iex> import Elmchemy.XString
      iex> left.(2).("Mulder")
      "Mu"
  
  
 
  """
  @spec left(integer, String.t) :: String.t
  curry left/2
  def left(n, str) do
    slice.(0).(n).(str)
  end

  @doc """
  Take *n* characters from the right side of a string.
  
  
      iex> import Elmchemy.XString
      iex> right.(2).("Scully")
      "ly"
  
  
 
  """
  @spec right(integer, String.t) :: String.t
  curry right/2
  def right(n, str) do
    slice.(negate.(n)).(length.(str)).(str)
  end

  @doc """
  Drop *n* characters from the left side of a string.
  
  
      iex> import Elmchemy.XString
      iex> drop_left.(2).("The Lone Gunmen")
      "e Lone Gunmen"
  
  
 
  """
  @spec drop_left(integer, String.t) :: String.t
  curry drop_left/2
  def drop_left(n, str) do
    slice.(n).(length.(str)).(str)
  end

  @doc """
  Drop *n* characters from the right side of a string.
  
  
      iex> import Elmchemy.XString
      iex> drop_right.(2).("Cigarette Smoking Man")
      "Cigarette Smoking M"
  
  
 
  """
  @spec drop_right(integer, String.t) :: String.t
  curry drop_right/2
  def drop_right(n, str) do
    slice.(0).(negate.(n)).(str)
  end

  @doc """
  Pad a string on both sides until it has a given length.
  
  
      iex> import Elmchemy.XString
      iex> pad.(5).(' ').("1")
      "  1  "
  
      iex> import Elmchemy.XString
      iex> pad.(5).(' ').("11")
      "  11 "
  
      iex> import Elmchemy.XString
      iex> pad.(5).(' ').("121")
      " 121 "
  
  
 
  """
  @spec pad(integer, char_list, String.t) :: String.t
  curry pad/3
  def pad(n, c, str) do
    right = div(( length.(str) + n ), 2)
    left = n
    str
    |> (pad_right.(right).(c)).()
    |> (pad_left.(left).(c)).()
  end

  @doc """
  Pad a string on the left until it has a given length.
  
  
      iex> import Elmchemy.XString
      iex> pad_left.(5).('.').("1")
      "....1"
  
      iex> import Elmchemy.XString
      iex> pad_left.(5).('.').("11")
      "...11"
  
      iex> import Elmchemy.XString
      iex> pad_left.(5).('.').("121")
      "..121"
  
  
 
  """
  @spec pad_left(integer, char_list, String.t) :: String.t
  curry pad_left/3
  def pad_left(n, c, str) do
    pad_leading.(str).(n).(from_char.(c))
  end

  @spec pad_leading(String.t, integer, String.t) :: String.t
  curryp pad_leading/3
  verify as: String.pad_leading/3
  def pad_leading(a1, a2, a3), do: String.pad_leading(a1, a2, a3)
  @doc """
  Pad a string on the right until it has a given length.
  
  
      iex> import Elmchemy.XString
      iex> pad_right.(5).('.').("1")
      "1...."
  
      iex> import Elmchemy.XString
      iex> pad_right.(5).('.').("11")
      "11..."
  
      iex> import Elmchemy.XString
      iex> pad_right.(5).('.').("121")
      "121.."
  
  
 
  """
  @spec pad_right(integer, char_list, String.t) :: String.t
  curry pad_right/3
  def pad_right(n, c, str) do
    pad_trailing.(str).(n).(from_char.(c))
  end

  @spec pad_trailing(String.t, integer, String.t) :: String.t
  curryp pad_trailing/3
  verify as: String.pad_trailing/3
  def pad_trailing(a1, a2, a3), do: String.pad_trailing(a1, a2, a3)
  @doc """
  Get rid of whitespace on both sides of a string.
  
  
      iex> import Elmchemy.XString
      iex> trim.("  hats  \\n")
      "hats"
  
  
 
  """
  @spec trim(String.t) :: String.t
  curry trim/1
  verify as: String.trim/1
  def trim(a1), do: String.trim(a1)
  @doc """
  Get rid of whitespace on the left of a string.
  
  
      iex> import Elmchemy.XString
      iex> trim_left.("  hats  \\n")
      "hats  \\n"
  
  
 
  """
  @spec trim_left(String.t) :: String.t
  curry trim_left/1
  verify as: String.trim_leading/1
  def trim_left(a1), do: String.trim_leading(a1)
  @doc """
  Get rid of whitespace on the right of a string.
  
  
      iex> import Elmchemy.XString
      iex> trim_right.("  hats  \\n")
      "  hats"
  
  
 
  """
  @spec trim_right(String.t) :: String.t
  curry trim_right/1
  verify as: String.trim_trailing/1
  def trim_right(a1), do: String.trim_trailing(a1)
  @doc """
  Break a string into words, splitting on chunks of whitespace.
  
  
      iex> import Elmchemy.XString
      iex> words.("How are \\t you? \\n Good?")
      ["How", "are", "you?", "Good?"]
  
  
 
  """
  @spec words(String.t) :: list(String.t)
  curry words/1
  verify as: String.split/1
  def words(a1), do: String.split(a1)
  @doc """
  Break a string into lines, splitting on newlines.
  
  
      iex> import Elmchemy.XString
      iex> lines.("How are you?\\nGood?")
      ["How are you?", "Good?"]
  
  
 
  """
  @spec lines(String.t) :: list(String.t)
  curry lines/1
  def lines(str) do
    split.("\n").(str)
  end

  @doc """
  Convert a string to all upper case. Useful for case-insensitive comparisons
  and VIRTUAL YELLING.
  
  
      iex> import Elmchemy.XString
      iex> to_upper.("skinner")
      "SKINNER"
  
  
 
  """
  @spec to_upper(String.t) :: String.t
  curry to_upper/1
  verify as: String.upcase/1
  def to_upper(a1), do: String.upcase(a1)
  @doc """
  Convert a string to all lower case. Useful for case-insensitive comparisons.
  
  
      iex> import Elmchemy.XString
      iex> to_lower.("X-FILES")
      "x-files"
  
  
 
  """
  @spec to_lower(String.t) :: String.t
  curry to_lower/1
  verify as: String.downcase/1
  def to_lower(a1), do: String.downcase(a1)
  @doc """
  Determine whether *any* characters satisfy a predicate.
  
  
      iex> import Elmchemy.XString
      iex> any.(XChar.is_digit).("90210")
      :true
  
      iex> import Elmchemy.XString
      iex> any.(XChar.is_digit).("R2-D2")
      :true
  
      iex> import Elmchemy.XString
      iex> any.(XChar.is_digit).("heart")
      :false
  
  
 
  """
  curry any/2
  def any(f, str) do
    XList.any.(f).(to_list.(str))
  end

  @doc """
  Determine whether *all* characters satisfy a predicate.
  
  
      iex> import Elmchemy.XString
      iex> all.(XChar.is_digit).("90210")
      :true
  
      iex> import Elmchemy.XString
      iex> all.(XChar.is_digit).("R2-D2")
      :false
  
      iex> import Elmchemy.XString
      iex> all.(XChar.is_digit).("heart")
      :false
  
  
 
  """
  curry all/2
  def all(f, str) do
    XList.all.(f).(to_list.(str))
  end

  @doc """
  See if the second string contains the first one.
  
  
      iex> import Elmchemy.XString
      iex> contains.("the").("theory")
      :true
  
      iex> import Elmchemy.XString
      iex> contains.("hat").("theory")
      :false
  
      iex> import Elmchemy.XString
      iex> contains.("THE").("theory")
      :false
  
  Use [`Regex.contains`](Regex#contains) if you need something more flexible.
  
  
 
  """
  @spec contains(String.t, String.t) :: boolean
  curry contains/2
  def contains(pattern, str) do
    contains_.(str).(pattern)
  end

  @spec contains_(String.t, String.t) :: boolean
  curryp contains_/2
  verify as: String. contains?/2
  def contains_(a1, a2), do: String. contains?(a1, a2)
  @doc """
  See if the second string starts with the first one.
  
  
      iex> import Elmchemy.XString
      iex> starts_with.("the").("theory")
      :true
  
      iex> import Elmchemy.XString
      iex> starts_with.("ory").("theory")
      :false
  
  
 
  """
  @spec starts_with(String.t, String.t) :: boolean
  curry starts_with/2
  def starts_with(prefix, str) do
    starts_with_.(str).(prefix)
  end

  @spec starts_with_(String.t, String.t) :: boolean
  curryp starts_with_/2
  verify as: String.starts_with?/2
  def starts_with_(a1, a2), do: String.starts_with?(a1, a2)
  @doc """
  See if the second string ends with the first one.
  
  
      iex> import Elmchemy.XString
      iex> ends_with.("the").("theory")
      :false
  
      iex> import Elmchemy.XString
      iex> ends_with.("ory").("theory")
      :true
  
  
 
  """
  @spec ends_with(String.t, String.t) :: boolean
  curry ends_with/2
  def ends_with(suffix, str) do
    ends_with_.(str).(suffix)
  end

  @spec ends_with_(String.t, String.t) :: boolean
  curryp ends_with_/2
  verify as: String.ends_with?/2
  def ends_with_(a1, a2), do: String.ends_with?(a1, a2)
  @doc """
  Get all of the indexes for a substring in another string.
  
  
      iex> import Elmchemy.XString
      iex> indexes.("i").("Mississippi")
      [1, 4, 7, 10]
  
      iex> import Elmchemy.XString
      iex> indexes.("ss").("Mississippi")
      [2, 5]
  
      iex> import Elmchemy.XString
      iex> indexes.("needle").("haystack")
      []
  
  
 
  """
  @spec indexes(String.t, String.t) :: list(integer)
  curry indexes/2
  def indexes(pattern, str) do
    matches_.(str).(pattern)
    |> (XList.map.(XTuple.first)).()
  end

  @spec matches_(String.t, any) :: list({integer, String.t})
  curryp matches_/2
  verify as: :binary.matches/2
  def matches_(a1, a2), do: :binary.matches(a1, a2)
  @doc """
  Alias for `indexes`.
  
 
  """
  @spec indices(String.t, String.t) :: list(integer)
  curry indices/2
  def indices(pattern, str) do
    indexes.(pattern).(str)
  end

  @doc """
  Try to convert a string into an int, failing on improperly formatted strings.
  
  
      iex> import Elmchemy.XString
      iex> XString.to_int.("123")
      {:ok, 123}
  
      iex> import Elmchemy.XString
      iex> XString.to_int.("-42")
      {:ok, -42}
  
      iex> import Elmchemy.XString
      iex> XString.to_int.("3.1")
      {:error, "could not convert string '3.1' to an Int"}
  
      iex> import Elmchemy.XString
      iex> XString.to_int.("31a")
      {:error, "could not convert string '31a' to an Int"}
  
  If you are extracting a number from some raw user input, you will typically
  want to use [`Result.withDefault`](Result#withDefault) to handle bad data:
  
  
      iex> import Elmchemy.XString
      iex> XResult.with_default.(0).(XString.to_int.("42"))
      42
  
      iex> import Elmchemy.XString
      iex> XResult.with_default.(0).(XString.to_int.("ab"))
      0
  
  
 
  """
  @spec to_int(String.t) :: Elmchemy.XResult.result
  curry to_int/1
  def to_int(str) do
    case to_int_.(str) do
      {:error, "argument error"} ->
        {:error, ( ( "could not convert string '" ++ str ) ++ "' to an Int" )}
      e ->
        e
    end
  end

  @spec to_int_(String.t) :: Elmchemy.XResult.result
  curryp to_int_/1
  def to_int_(a1) do 
    try_catch fn -> 
      String.to_integer(a1)
    end
  end
  @doc """
  Try to convert a string into a float, failing on improperly formatted strings.
  
  
      iex> import Elmchemy.XString
      iex> XString.to_float.("123")
      {:ok, 123.0}
  
      iex> import Elmchemy.XString
      iex> XString.to_float.("-42")
      {:ok, -42.0}
  
      iex> import Elmchemy.XString
      iex> XString.to_float.("3.1")
      {:ok, 3.1}
  
      iex> import Elmchemy.XString
      iex> XString.to_float.("31a")
      {:error, "could not convert string '31a' to a Float"}
  
  If you are extracting a number from some raw user input, you will typically
  want to use [`Result.withDefault`](Result#withDefault) to handle bad data:
  
  
      iex> import Elmchemy.XString
      iex> XResult.with_default.(0).(XString.to_float.("42.5"))
      42.5
  
      iex> import Elmchemy.XString
      iex> XResult.with_default.(0).(XString.to_float.("cats"))
      0
  
  
 
  """
  @spec to_float(String.t) :: Elmchemy.XResult.result
  curry to_float/1
  def to_float(str) do
    real = if contains.(".").(str) do str else ( str ++ ".0" ) end
    case to_float_.(real) do
      {:error, "argument error"} ->
        {:error, ( ( "could not convert string '" ++ str ) ++ "' to a Float" )}
      e ->
        e
    end
  end

  @spec to_float_(String.t) :: Elmchemy.XResult.result
  curryp to_float_/1
  def to_float_(a1) do 
    try_catch fn -> 
      String.to_float(a1)
    end
  end
  @doc """
  Convert a string to a list of characters.
  
  
      iex> import Elmchemy.XString
      iex> to_list.("abc")
      ['a', 'b', 'c']
  
  
 
  """
  @spec to_list(String.t) :: list(char_list)
  curry to_list/1
  def to_list(str) do
    charlist = to_charlist_.(str)
    map_.(charlist).(XList.singleton)
  end

  #  It's ugly but it's the only way since there's no
  #    Chars in Elixir

  @spec to_charlist_(String.t) :: list(integer)
  curryp to_charlist_/1
  verify as: String.to_charlist/1
  def to_charlist_(a1), do: String.to_charlist(a1)
  @spec map_(list(integer), (integer -> list(integer))) :: list(char_list)
  curryp map_/2
  def map_(a1, a2), do: Enum.map(a1, fn (x1) -> a2.(x1) end)
  @doc """
  Convert a list of characters into a String. Can be useful if you
  want to create a string primarily by consing, perhaps for decoding
  something.
  
  
      iex> import Elmchemy.XString
      iex> from_list.(['a', 'b', 'c'])
      "abc"
  
  
 
  """
  @spec from_list(list(char_list)) :: String.t
  curry from_list/1
  def from_list(list) do
    join_chars_.(list).("")
  end

  @spec join_chars_(list(char_list), String.t) :: String.t
  curryp join_chars_/2
  verify as: Enum.join/2
  def join_chars_(a1, a2), do: Enum.join(a1, a2)
end
