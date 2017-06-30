defmodule Elmchemy.Glue do
  @arg_names ~w[a b c d e f g h i j k l m n o p q r s t u v w x y z]a

  def try_catch(func) do
    try do
        {:ok, func.()}
    rescue
      e -> {:error, e.message}
    end
  end


  defmacro curry({:/, _, [{name, _, _}, arity]}) do
    args =
      1..arity |> Enum.map(&({:"arg#{&1}", [], Elixir}))

    define_curried(:def, name, args)
  end

  defmacro curryp({:/, _, [{name, _, _}, arity]}) do
    args =
      1..arity |> Enum.map(&({:"arg#{&1}", [], Elixir}))

    define_curried(:defp, name, args)
  end

  defmacro defcurry(definition, _opts \\ [], do: body) do
    {fun, args} = Macro.decompose_call(definition)
    quote do
      unquote(define_curried(:def, fun, args))
      def unquote(fun)(unquote_splicing(args)) do
        unquote(body)
      end
    end
  end

  defmacro defcurryp(definition, _opts \\ [], do: body) do
    {fun, args} = Macro.decompose_call(definition)
    quote do
      unquote(define_curried(:defp, fun, args))
      defp unquote(fun)(unquote_splicing(args)) do
        unquote(body)
      end
    end
  end

  defp define_curried(:def, name, args) do
    quote do
      def unquote(name)() do
        unquote(do_curry(name, args))
      end
    end
  end
  defp define_curried(:defp, name, args) do
    quote do
      defp unquote(name)() do
        unquote(do_curry(name, args))
      end
    end
  end

  defp do_curry(fun, args), do: do_curry(fun, args, args)
  defp do_curry(fun, [h | args], all) do
    quote do fn unquote(h) -> unquote(do_curry(fun, args, all)) end end
  end
  defp do_curry(fun, [], args) do
    quote do: unquote(fun)(unquote_splicing(args))
  end

  ## ARGUMENT MANIPULATION

  @doc """
  Helper function used in argument manipulation macros.
  """

  defp take_arguments(many) do
    for arg_name <- Enum.take(@arg_names, many), do: {arg_name, [], Elixir}
  end

  @doc """
  Defines a function head that delegates to another module with all arguments in reversed order (a, b, c becomes c, b, a)
  defreverse foldl/3, to: List.foldl
  ### being equivalent of
  def foldl(x1, x2, x3), do: List.foldl(x3, x2, x1)
  ```
  """

  defmacro defreverse({name, _,_}, to: {:/, _, [{function, call_meta, _ }, arity]} ) do
    args = take_arguments(arity)
    function_definition = { name, call_meta, args}
    call = {function, call_meta, Enum.reverse(args) }

    quote do
      def unquote(function_definition), do: unquote(call)
    end
  end

  @doc """
  Defines a function head that delegates to another module with last argument being first ( a, b, c becomes c, a, b)
  defswap foldl/3, to: List.foldl
  ### being equivalent of
  def foldl(x1, x2, x3), do: List.foldl(x3, x1, x2)
  """

  defmacro defswap({name, _,_}, to: {:/, _, [{function, call_meta, _ }, arity]}) do
    args = take_arguments(arity)
    function_definition = { name, call_meta, args}
    {first, [second]} = Enum.split(args,arity-1)
    call = {function, call_meta, [second | first] }

    quote do
      def unquote(function_definition), do: unquote(call)
    end
  end

  ## TYPE CHECKING
  defmacro verify(as: {:/, _, [{call, _, []}, arity1]}) do
    {mod, function} = case call do
      {:., _, [{:__aliases__, _, mods}, fun]} ->
        mod = Module.concat(mods)
        {mod, fun}
      {:., _, [mod, fun]} ->
        {mod, fun}
    end
    quote do
      spec_ast = Module.get_attribute(__MODULE__, :spec) |> hd |> elem(1)
      {{:spec, {fun1, _}, spec}, _line} =
        Kernel.Typespec.translate_spec(:spec, spec_ast, __ENV__)
      right =
        Elmchemy.Spec.find(unquote(mod), unquote(function), unquote(arity1))
      left = {{fun1, unquote(arity1)}, [spec]}

      __MODULE__
      |> Module.put_attribute(:verify_type, [left, right, __MODULE__, unquote(mod)])
    end
  end

  defmacro typetest(mod) do
    Macro.expand(mod, __CALLER__).__type_tests__
    |> Enum.each(fn args ->
      Kernel.apply(Elmchemy.Spec, :compare!, args)
    end)
  end
end
