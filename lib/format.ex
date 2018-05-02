defmodule Elchemy.Format do

  @doc "Some doc"
  @spec inspect(term()) :: String.t()

  def inspect(term) when is_map(term) do
    inner = term |> Enum.map(fn {key, value} ->
      (key |> Kernel.to_string) <> " = " <> (value |> Kernel.to_string)
    end)
    "{ " <> Enum.join(inner, ", ") <> " }"
  end

  def inspect(term) do
    is_atom_first(term)
  end

  defp is_atom_first(term) when is_tuple(term) do
      [head | rest] = term |> Tuple.to_list
      if is_atom(head) do
          term |> Tuple.to_list() |> Enum.join(" ") |> String.capitalize
      else
        inner = term |> Tuple.to_list()
        "(" <> Enum.join(inner, ", ") <> ")"
      end
  end


end
