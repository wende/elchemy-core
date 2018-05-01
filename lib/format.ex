defmodule Elchemy.Format do

  @doc "Some doc"
  @spec inspect(term()) :: String.t()
  def inspect(term) do
    # Tutaj kod zamiast tego
    Kernel.inspect(term)
  end
end
