defmodule Elchemy.Format do

  @doc "Some doc"
  @spec inspect(term()) :: String.t()
  def inspect(term) when is_tuple(term) do

  end

  def inspect(term) when is_map(term) do
    inner = term |> Enum.map(fn {key, value} ->
      (key |> Kernel.to_string) <> " = " <> (value |> Kernel.to_string)
    end)
    "{ " <> Enum.join(inner, ", ") <> " }"
  end

  def inspect(term) do
    check_number(term)
  end

  defp check_number(term) when is_tuple(term) do
    if Kernel.tuple_size(term) > 2 do
      term |> Tuple.to_list() |> Enum.join(" ") |> String.capitalize
    else
      [head | rest] = term |> Tuple.to_list
      if is_atom(head) do
        false
      else
        term |> List.to_string
        "(" <> Enum.join(rest, ", ") <> ")"
      end
    end

  end

end
