defmodule Elchemy.Let do
  defmacro __before_compile__(_env) do
    lets = Module.get_attribute(__CALLER__.module, :let)
    for {{name, body}, i} <- Enum.with_index(lets) do
      IO.inspect(Macro.to_string(body))
      var = Macro.var(:"#{name}_#{i}", __MODULE__)
      IO.inspect(var)
      quote do
        defp unquote(var), do: unquote(body)
      end
    end
  end

  defmacro let(name, body) do
    {caller, _arity} = __CALLER__.function
    inner = quote do unquote(body).() end
    define("#{caller}_#{name}" , inner, __CALLER__)
  end

  defmacro context() do
    __CALLER__.function
  end

  defp define(name, body, env) do
    Module.put_attribute(env.module, :let, {name, body})
    :ok
  end
end
