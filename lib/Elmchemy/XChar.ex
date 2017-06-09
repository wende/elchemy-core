
# Compiled using Elmchemy v0.3.25
defmodule Elmchemy.XChar do
  use Elmchemy

  @doc """
  Functions for working with characters. Character literals are enclosed in
  `'a'` pair of single quotes.
  
  
  # Classification
  
  @docs isUpper, isLower, isDigit, isOctDigit, isHexDigit
  
  
  # Conversion
  
  @docs toUpper, toLower
  
  
  # Key Codes
  
  @docs KeyCode, toCode, fromCode
  
  
 
  """
  import Elmchemy
  @doc """
  True for char between first and second argument
  
  
      iex> import Elmchemy.XChar
      iex> between.('a').('z').('b')
      :true
  
      iex> import Elmchemy.XChar
      iex> between.('1').('9').('5')
      :true
  
      iex> import Elmchemy.XChar
      iex> between.('A').('Z').('g')
      :false
  
  
 
  """
  @spec is_between() :: (char_list -> (char_list -> (char_list -> boolean)))
  @spec is_between(char_list, char_list, char_list) :: boolean
  curryp is_between/3
  defp is_between(low, high, char) do
    code = to_code.(char)
    code >= to_code.(low) && code <= to_code.(high)
  end

  @doc """
  True for upper case ASCII letters.
  
  
      iex> import Elmchemy.XChar
      iex> is_upper.('D')
      :true
  
      iex> import Elmchemy.XChar
      iex> is_upper.('A')
      :true
  
      iex> import Elmchemy.XChar
      iex> is_upper.('x')
      :false
  
  
 
  """
  @spec is_upper() :: (char_list -> boolean)
  @spec is_upper(char_list) :: boolean
  curry is_upper/1
  def is_upper(char) do
    is_between.('A').('Z').(char)
  end

  @doc """
  True for lower case ASCII letters.
  
  
      iex> import Elmchemy.XChar
      iex> is_lower.('d')
      :true
  
      iex> import Elmchemy.XChar
      iex> is_lower.('a')
      :true
  
      iex> import Elmchemy.XChar
      iex> is_lower.('X')
      :false
  
  
 
  """
  @spec is_lower() :: (char_list -> boolean)
  @spec is_lower(char_list) :: boolean
  curry is_lower/1
  def is_lower(char) do
    is_between.('a').('z').(char)
  end

  @doc """
  True for ASCII digits `[0-9]`.
  
  
      iex> import Elmchemy.XChar
      iex> is_digit.('1')
      :true
  
      iex> import Elmchemy.XChar
      iex> is_digit.('9')
      :true
  
      iex> import Elmchemy.XChar
      iex> is_digit.('a')
      :false
  
  
 
  """
  @spec is_digit() :: (char_list -> boolean)
  @spec is_digit(char_list) :: boolean
  curry is_digit/1
  def is_digit(char) do
    is_between.('0').('9').(char)
  end

  @doc """
  True for ASCII octal digits `[0-7]`.
  
  
      iex> import Elmchemy.XChar
      iex> is_oct_digit.('7')
      :true
  
      iex> import Elmchemy.XChar
      iex> is_oct_digit.('5')
      :true
  
      iex> import Elmchemy.XChar
      iex> is_oct_digit.('9')
      :false
  
  
 
  """
  @spec is_oct_digit() :: (char_list -> boolean)
  @spec is_oct_digit(char_list) :: boolean
  curry is_oct_digit/1
  def is_oct_digit(char) do
    is_between.('0').('7').(char)
  end

  @doc """
  True for ASCII hexadecimal digits `[0-9a-fA-F]`.
  
  
      iex> import Elmchemy.XChar
      iex> is_hex_digit.('d')
      :true
  
      iex> import Elmchemy.XChar
      iex> is_hex_digit.('D')
      :true
  
      iex> import Elmchemy.XChar
      iex> is_hex_digit.('x')
      :false
  
  
 
  """
  @spec is_hex_digit() :: (char_list -> boolean)
  @spec is_hex_digit(char_list) :: boolean
  curry is_hex_digit/1
  def is_hex_digit(char) do
    is_digit.(char) || is_between.('a').('f').(char) || is_between.('A').('F').(char)
  end

  @doc """
  Convert to upper case.
  
  
      iex> import Elmchemy.XChar
      iex> to_upper.('a')
      'A'
  
  
 
  """
  @spec to_upper() :: (char_list -> char_list)
  @spec to_upper(char_list) :: char_list
  curry to_upper/1
  verify as: :string.to_upper/1
  def to_upper(a1), do: :string.to_upper(a1)
  @doc """
  Convert to lower case.
  
  
      iex> import Elmchemy.XChar
      iex> to_lower.('A')
      'a'
  
  
 
  """
  @spec to_lower() :: (char_list -> char_list)
  @spec to_lower(char_list) :: char_list
  curry to_lower/1
  verify as: :string.to_lower/1
  def to_lower(a1), do: :string.to_lower(a1)
  #  {-| Convert to upper case, according to any locale-specific case mappings. -}
  #  toLocaleUpper : Char -> Char
  #  toLocaleUpper =
  #    Native.Char.toLocaleUpper
  #  {-| Convert to lower case, according to any locale-specific case mappings. -}
  #  toLocaleLower : Char -> Char
  #  toLocaleLower =
  #    Native.Char.toLocaleLower
  @doc """
  Keyboard keys can be represented as integers. These are called *key codes*.
  You can use [`toCode`](#toCode) and [`fromCode`](#fromCode) to convert between
  key codes and characters.
  
 
  """
  @doc """
  Convert to key code.
  
  
      iex> import Elmchemy.XChar
      iex> to_code.('a')
      97
  
  
 
  """
  @spec to_code() :: (char_list -> integer)
  @spec to_code(char_list) :: integer
  curry to_code/1
  def to_code(a1), do: Kernel.hd(a1)
  @doc """
  Convert from key code.
  
  
      iex> import Elmchemy.XChar
      iex> from_code.(97)
      'a'
  
  
 
  """
  @spec from_code() :: (integer -> char_list)
  @spec from_code(integer) :: char_list
  curry from_code/1
  def from_code(code) do
    insert_at_.([]).(0).(code)
  end

  @spec insert_at_() :: (list(any) -> (integer -> (any -> char_list)))
  @spec insert_at_(list(any), integer, any) :: char_list
  curryp insert_at_/3
  verify as: List.insert_at/3
  def insert_at_(a1, a2, a3), do: List.insert_at(a1, a2, a3)
end
