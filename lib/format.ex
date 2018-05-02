defmodule Elchemy.Format do

  @doc "Some doc"
  @spec inspect(term()) :: String.t()
  def inspect(term) when is_tuple(term) do
      term |> Tuple.to_list() |> Enum.join(" ") |> String.capitalize
  end

  def inspect(term) when is_map(term) do
    inner = term |> Enum.map(fn {key, value} ->
      (key |> Kernel.to_string) <> " = " <> (value |> Kernel.to_string)
    end)
    "{ " <> Enum.join(inner, ", ") <> " }"
  end

  def inspect(term) do
    defp inspect_tuple when is_tuple(term) do
      [head | rest] = term |> Tuple.to_list
      if is_atom(head) do
        false
      else
        [head | rest] = [nil | (Kernel.to_string(rest))]
        "(" <> Enum.join(rest, ", ") <> ")"
      end
    end
  end

end
