defmodule Elchemy.Elixir.NativeAst do

  @doc """
  Serializes Elixir AST represented by Elchemy
  """
  def serialize({:application, ex, args}) do
    quote do
      unquote(serialize(ex))(unquote_splicing(Enum.map(args, &serialize/1)))
    end
  end
  def serialize({:variable, name}) do
    Macro.var(String.to_atom(name), Elixir)
  end
  def serialize({:do, exps}) do
    [do: {:__block__, [], Enum.map(exps, &serialize/1)}]
  end

  def serialize({:atom, value}), do: String.to_atom(value)
  def serialize({_, value}), do: value

end
