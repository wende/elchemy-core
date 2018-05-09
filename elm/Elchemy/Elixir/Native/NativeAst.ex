defmodule Elchemy.Elixir.NativeAst do

  defmodule QuotedExpressionError do
    defexception message: "You need to unquote the expression first!"
  end

  @doc """
  Serializes Elixir AST represented by Elchemy
  """
  @spec serialize(Elchemy.Elixir.Ast.compiled_expression()) :: term()
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
  def serialize({:tuple, value}), do: List.to_tuple(value)
  def serialize({:list, value}), do: Enum.map(value, &serialize/1)
  def serialize(:quotation), do: raise %QuotedExpressionError{}

  # Values
  def serialize({:value, {:atom, value}}), do: String.to_atom(value)
  def serialize({:value, {type, value}}) when type in [:int, :string], do: value
  def serialize({:value, value}), do: value

  # Hidden quote
  def serialize({:quote, q}) do
     quote do unquote(q) end
   end

  @doc """
  Substitutes quotations with the given value
  """
  @spec substitute(term(), Elchemy.Elixir.Ast.expression()) :: Elchemy.Elixir.Ast.compiled_expression()
  def substitute(value, exp), do: do_sub(exp, value)

  defp do_sub({:application, ex, args}, v), do: {:application, do_sub(ex, v), sub_each(args, v)}
  defp do_sub({:variable, _var} = v, _v), do: v
  defp do_sub({:value, _val} = v, _v), do: v
  defp do_sub({:do, exps}, v), do: {:do, sub_each(exps, v)}
  defp do_sub(:quotation, q), do: {:quote, safe_quote(q)}
  defp do_sub({:tuple, exps}, v), do: {:tuple, sub_each(exps, v)}
  defp do_sub({:list, exps}, v), do: {:list, sub_each(exps, v)}

  defp sub_each(exps, value), do: Enum.map(exps, fn exp -> do_sub(exp, value) end)

  defp safe_quote(v) when is_function(v) do
    info = :erlang.fun_info(v)
    module = info[:module]
    name = info[:name]
    arity = info[:arity]
    quote do
      &unquote(module).unquote(name)/unquote(arity)
    end |> IO.inspect(label: "fun")
  end
  defp safe_quote(v), do: v

end
