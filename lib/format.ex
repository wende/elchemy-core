defmodule Elchemy.Format do

  import Kernel, except: [inspect: 1]

  @doc "Some doc"
  @spec inspect(term()) :: String.t()

  def inspect(term) when is_map(term) do
    inner = term |> Enum.map(fn {key, value} ->
      (key |> Kernel.to_string) <> " = " <> (value |> Kernel.to_string)
    end)
    "{ " <> Enum.join(inner, ", ") <> " }"
  end

  def inspect(term) when is_tuple(term) do
      [head | _rest] = term |> Tuple.to_list
      if is_atom(head) do
          term |> Tuple.to_list() |> Enum.join(" ") |> String.capitalize
      else
        inner = term |> Tuple.to_list()
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
end
