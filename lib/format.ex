defmodule Elchemy.Format do

  import Kernel, except: [inspect: 1]

  @doc "Some doc"
  @spec inspect(term()) :: String.t()

  def inspect(term) when is_map(term) do
    case Map.to_list(term) do
      [] -> "Dict.fromList []"
    [{key, _value} | _] when is_atom(key) ->
      inner = term |> Enum.map(fn {key, value} ->
        (key |> inspect()) <> " = " <> (value |> inspect())
      end)
      "{ " <> Enum.join(inner, ", ") <> " }"
    [{_key, _value} | _] ->
      inner = term |> Enum.map(fn {key, value} ->
        (key |> inspect()) <> " = " <> (value |> inspect())
      end)
      "Dict.fromList [{ " <> Enum.join(inner, ", ") <> " }]"
    end

  end

  def inspect(term) when is_tuple(term) do
      [head | rest] = term |> Tuple.to_list
      if is_atom(head) do
          left = (head |> Atom.to_string() |> String.capitalize())
          right = (rest |> Enum.map(&inspect/1) |> Enum.join(" "))
          left <> " " <> right
      else
        inner = term |> Tuple.to_list() |> Enum.map(&inspect/1)
        "(" <> Enum.join(inner, ", ") <> ")"
      end
  end

  def inspect(term) when is_list(term) do
    inner =
      term
      |> Enum.map(fn x -> inspect(x) end)
      |> Enum.join(", ")

    "[" <> inner <> "]"
  end

  def inspect(x), do: to_string(x)
end
