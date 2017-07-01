
# Compiled using Elmchemy v0.3.33
defmodule Elmchemy.XRegex do
  use Elmchemy

  @doc """
  A library for working with regular expressions. It uses [the
  same kind of regular expressions accepted by JavaScript](https://developer.mozilla.org/en/docs/Web/JavaScript/Guide/Regular_Expressions).
  
  
  # Create
  
  @docs Regex, regex, escape, caseInsensitive
  
  
  # Helpful Data Structures
  
  These data structures are needed to help define functions like [`find`](#find)
  and [`replace`](#replace).
  
  @docs HowMany, Match
  
  
  # Use
  
  @docs contains, find, replace, split
  
  
 
  """
  import XMaybe, only: []
  @doc """
  A regular expression, describing a certain set of strings.
  
 
  """
  @type regex :: :regex

  @doc """
  Escape strings to be regular expressions, making all special characters
  safe. So `regex (escape "^a+")` will match exactly `"^a+"` instead of a series
  of `a`&rsquo;s that start at the beginning of the line.
  
 
  """
  @spec escape(String.t) :: String.t
  curry escape/1
  verify as: XRegex.escape/1
  def escape(a1), do: XRegex.escape(a1)
  @doc """
  Create a Regex that matches patterns [as specified in JavaScript](https://developer.mozilla.org/en/docs/Web/JavaScript/Guide/Regular_Expressions#Writing_a_Regular_Expression_Pattern).
  
  Be careful to escape backslashes properly! For example, `"\\w"` is escaping the
  letter `w` which is probably not what you want. You probably want `"\\\\w"`
  instead, which escapes the backslash.
  
  
 
  """
  @spec regex(String.t) :: regex
  curry regex/1
  verify as: XRegex.regex/1
  def regex(a1), do: XRegex.regex(a1)
  @doc """
  Make a regex case insensitive
  
 
  """
  @spec case_insensitive(regex) :: regex
  curry case_insensitive/1
  verify as: XRegex.caseInsensitive/1
  def case_insensitive(a1), do: XRegex.caseInsensitive(a1)
  @doc """
  Check to see if a Regex is contained in a string.
  
  
      iex> import Elmchemy.XRegex
      iex> contains.(regex.("123")).("12345")
      :true
  
      iex> import Elmchemy.XRegex
      iex> contains.(regex.("b+")).("aabbcc")
      :true
  
  
      iex> import Elmchemy.XRegex
      iex> contains.(regex.("789")).("12345")
      :false
  
      iex> import Elmchemy.XRegex
      iex> contains.(regex.("z+")).("aabbcc")
      :false
  
  
 
  """
  @spec contains(regex, String.t) :: boolean
  curry contains/2
  verify as: XRegex.contains/2
  def contains(a1, a2), do: XRegex.contains(a1, a2)
  @doc """
  A `Match` represents all of the details about a particular match in a string.
  Here are details on each field:
  
    - `match` &mdash; the full string of the match.
    - `submatches` &mdash; a regex might have [subpatterns, surrounded by
      parentheses](https://developer.mozilla.org/en/docs/Web/JavaScript/Guide/Regular_Expressions#Using_Parenthesized_Substring_Matches).
      If there are N subpatterns, there will be N elements in the `submatches` list.
      Each submatch in this list is a `Maybe` because not all subpatterns may trigger.
      For example, `(regex "(a+)|(b+)")` will either match many `a`&rsquo;s or
      many `b`&rsquo;s, but never both.
    - `index` &mdash; the index of the match in the original string.
    - `number` &mdash; if you find many matches, you can think of each one
      as being labeled with a `number` starting at one. So the first time you
      find a match, that is match `number` one. Second time is match `number` two.
      This is useful when paired with `replace All` if replacement is dependent on how
      many times a pattern has appeared before.
  
  
 
  """
  @doc """
  `HowMany` is used to specify how many matches you want to make. So
  `replace All` would replace every match, but `replace (AtMost 2)` would
  replace at most two matches (i.e. zero, one, two, but never three or more).
  
 
  """
  @type how_many :: :all | {:at_most, integer}

  @doc """
  Find matches in a string:
  
      findTwoCommas =
          find (AtMost 2) (regex ",")
  
  
  
      places =
          find All (regex "[oi]n a (\\\\w+)") "I am on a boat in a lake."
  
  
  
  
 
  """
  @spec find(how_many, regex, String.t) :: list(%{
    match: String.t,
    submatches: list({String.t} | nil),
    index: integer,
    number: integer
  })
  curry find/3
  verify as: XRegex.find/3
  def find(a1, a2, a3), do: XRegex.find(a1, a2, a3)
  @doc """
  Replace matches. The function from `Match` to `String` lets
  you use the details of a specific match when making replacements.
  
      devowel =
          replace All (regex "[aeiou]") (\\_ -> "")
  
  
  
      reverseWords =
          replace All (regex "\\\\w+") (\\{ match } -> String.reverse match)
  
  
  
  
 
  """
  @spec replace(how_many, regex, (%{
    match: String.t,
    submatches: list({String.t} | nil),
    index: integer,
    number: integer
  } -> String.t), String.t) :: String.t
  curry replace/4
  verify as: XRegex.replace/4
  def replace(a1, a2, a3, a4), do: XRegex.replace(a1, a2, fn (x1) -> a3.(x1) end, a4)
  @doc """
  Split a string, using the regex as the separator.
  
  
      iex> import Elmchemy.XRegex
      iex> split.({:at_most, 1}).(regex.(",")).("tom,99,90,85")
      ["tom", "99,90,85"]
  
  
      iex> import Elmchemy.XRegex
      iex> split.(:all).(regex.(",")).("a,b,c,d")
      ["a", "b", "c", "d"]
  
  
 
  """
  @spec split(how_many, regex, String.t) :: list(String.t)
  curry split/3
  verify as: XRegex.split/3
  def split(a1, a2, a3), do: XRegex.split(a1, a2, a3)
end
