defmodule Elchemy.Glue do
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
  defswap foldl, to: List.foldl/3
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
  defmacro verify(as: {:/, _, [{call, _, []}, arity]}) do
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
      right = {unquote(mod), unquote(function), unquote(arity)}
        # Elchemy.Spec.find(unquote(mod), unquote(function), unquote(arity1))
      left = {{fun1, unquote(arity)}, [spec]}

      __MODULE__
      |> Module.put_attribute(:verify_type, [left, right, __MODULE__, unquote(mod)])
    end
  end

  defmacro typetest(mod) do
    Macro.expand(mod, __CALLER__).__type_tests__
    |> Enum.each(fn args ->
      Kernel.apply(Elchemy.Spec, :compare!, args)
    end)
  end

  ## -- Mutually recursive Let..in using Y combinator
  defmacro let(clauses) do
    right = for {name, _} <- clauses do
      quote do
        &(fun.(unquote(name)).(&1))
      end
    end

    names = for {n, _} <- clauses, do: Macro.var(n, nil)
    underscored = for _ <- names, do: Macro.var(:_, nil)

    whole = quote do
      {unquote_splicing(names)} = {unquote_splicing(right)}
      {unquote_splicing(underscored)} = {unquote_splicing(names)}
    end

    inner = {:fn, [], for {name, c} <- clauses do
      {:'->', [], [[name], quote do
          unquote(whole)
          unquote(c)
      end]}
    end}

    quote do
      fun = rec fun, unquote(inner)
      unquote(whole)
    end
  end

  ## -- Y-combinator

  defmacro rec(name, {:fn, meta, [c|_clauses]} = f) do
    var = if is_atom(name), do: Macro.var(name, nil), else: name
    n = num_args(c)
    args = n_args(n, [])
    namedf = quote do
      fn (unquote(var)) ->
        _ = unquote(var)
        unquote(f)
      end
    end
    combinator_fun = combinator_ast(namedf, args, meta)
    quote do
      combinator = unquote(combinator_fun)
      combinator.(combinator)
    end
  end

  defp combinator_ast(namedf, args, meta) do
    x = Macro.var(:x, __MODULE__)
    inner = fn_ast(args, quote do unquote(x).(unquote(x)).(unquote_splicing(args)) end, meta)
    quote do
      fn unquote(x) -> unquote(namedf).(unquote(inner)) end
    end
  end

  defp fn_ast(vars, body, _meta) do
    quote do
      fn unquote_splicing(vars) ->
        unquote(body)
      end
    end
  end

  defp n_args(0, args), do: args
  defp n_args(n, args), do: n_args(n - 1, [Macro.var(:"a#{n - 1}", __MODULE__) | args])

  defp num_args({:->, _, [fn_head | _fn_body]}), do: num_args_fn_head(fn_head)

  defp num_args_fn_head([{:when, _, args} | _]), do: Enum.take_while(args, &is_arg/1) |> length()
  defp num_args_fn_head(vars) when is_list(vars), do: length(vars)

  defp is_arg({a, _m, c}) when is_atom(a) and is_atom(c), do: :true
  defp is_arg(_), do: :false

end
