defmodule Elmchemy.Spec do
  require Logger

  def find(module, function, arity) do
    result = module
      |> Kernel.Typespec.beam_specs()
      |> Enum.find(fn {name, _} -> name == {function, arity} end)
    if result == nil do
      raise "No function #{module}.#{function}/#{arity} found"
    else
      result
    end
  end

  def compare!(a, b, mod1, mod2 \\ nil) do
    mod2 = mod2 || mod1
    result = compare(a, b, mod1, mod2)
    if result == :ok do
      :ok
    else
      raise Elmchemy.SpecError, message: """
      Type definition mismatch
      These type signatures are different:
        #{gen_elm a, mod1}
        #{gen_elm b, mod2}
      Because of #{inspect result}
      """
    end
  end
  @doc """
  Check if left spec is a subtype of a right one
  """
  def compare(l = {{_, arity1}, [spec1]}, r = {{f, arity2}, [spec2 | rest]}, mod1, mod2 \\ nil) do
    IO.inspect(r)
    IO.puts "\n"
    mod2 = mod2 || mod1
    compared = do_compare(spec1, spec2, mod1, mod2)
    cond do
      arity1 != arity2 ->
        {:error, "functions have different arity"}
      compared == :ok ->
         :ok
      rest == [] ->
        compared
      true ->
        compare(l, {{f, arity2}, rest}, mod1, mod2)
    end
  end
  defp do_compare(same, same, _mod1, _mod2), do: :ok
  defp do_compare(l, {:type, _, :bounded_fun, [fun | constraints]}, m1, m2) do
    do_compare(l, fun, m1, m2)
  end
  defp do_compare({:type, _, :list, [{:type, _, :any, []}]}, {:type, _, :list, []}, _m1, _m2) do
    :ok
  end
  defp do_compare({:type, _, type, []}, {:type, _, type, []}, _, _), do: :ok
  defp do_compare(_, {:type, _, :any, []}, _, _), do: :ok
  defp do_compare(_, {:type, _, :term, []}, _, _), do: :ok
  defp do_compare(_, {:var, _, _}, _, _), do: :ok
  defp do_compare(t1 = {:type, _, type, args1}, t2 = {:type, _, type, args2}, m1, m2) do
    if length(args1) != length(args2) do
      {:error, "#{gen_spec t1, m1} is not the same length as #{gen_spec t2, m2}"}
    else
      [args1, args2]
      |> Enum.zip()
      |> Enum.map(fn {arg1, arg2} -> do_compare(arg1, arg2, m1, m2) end)
      |> Enum.find(fn a -> a != :ok end)
      |> (&(&1 || :ok)).()
    end
  end
  defp do_compare(a = {:type, _, :union, args}, b, m1, m2) do
    if Enum.any?(args, fn a -> do_compare(a, b, m1, m2) == :ok end)  do
      :ok
    else
      {:error, "none of #{gen_spec a, m1} is a subtype of #{gen_spec b, m2}"}
    end
  end
  defp do_compare(a, b = {:type, _, :union, args}, m1, m2) do
    if Enum.any?(args, fn b -> do_compare(a, b, m1, m2) == :ok end)  do
      :ok
    else
      {:error, "none of #{gen_spec a, m1} is a subtype of #{gen_spec b, m2}"}
    end
  end
  defp do_compare(t1 = {:type, _, _type1, _arg1}, t2 = {:type, _, _type2, _arg2}, m1, m2)
  do
    compare_types(t1, t2, m1, m2)
  end
  defp do_compare({:var, _, _}, {:var, _, _}, _, _), do: :ok
  defp do_compare({:user_type, _, name, []}, {:user_type, _, name, []}, _, _) do
    :ok
  end
  defp do_compare({:user_type, _, name, []}, b, m1, m2) do
    do_compare(resolve_type(name, m1), b, m1, m2)
  end
  defp do_compare(a, {:user_type, _, name, []}, m1, m2) do
    do_compare(a, resolve_type(name, m2), m1, m2)
  end
  defp do_compare({:remote_type, _, path}, {:remote_type, _, path}, _, _) do
    :ok
  end
  defp do_compare({:remote_type, _, path}, b, m1, m2) do
    {module, name} = get_path_and_name(path)
    do_compare(resolve_type(name, module), b, m1, m2)
  end
  defp do_compare(a, {:remote_type, _, path}, m1, m2) do
    {module, name} = get_path_and_name(path)
    do_compare(a, resolve_type(name, module), m1, m2)
  end
  defp do_compare(t1 = {:type, _, type1, _},  t2 = {type2, _, _val}, m1, _m2) do
    cond do
      type1 == type2 -> :ok
      type1 == :integer && type2 == :number -> :ok
      type1 == :integer && type2 == :pos_integer -> :ok
      type1 == :integer && type2 == :neg_integer -> :ok
      type1 == :integer && type2 == :float -> :ok

      type2 == :integer && type1 == :number -> :ok
      type2 == :integer && type1 == :pos_integer -> :ok
      type2 == :integer && type1 == :neg_integer -> :ok
      type2 == :integer && type1 == :float -> :ok

      type1 == :float && type2 == :number -> :ok
      type1 == :float && type2 == :integer -> :ok

      type2 == :float && type1 == :number -> :ok
      type2 == :float && type1 == :integer -> :ok

      true -> {:error, "Type instance #{inspect t2} is not of type #{gen_spec t1, m1} (#{inspect t1})"}
    end
  end

  defp compare_types(t1 = {:type, _, type1, arg1}, t2 = {:type, _, type2, arg2}, m1, m2) do
    case IO.inspect {{type1, arg1}, {type2, arg2}} do
      {same, same} -> :ok
      {{:list, [{:type, _, :any, _}]}, {:list, []}} -> :ok
      {{:list, []}, {:list, [{:type, _, :any, _}]}} -> :ok
      {{:string, []}, {:list, []}} -> :ok
      {{:list, []}, {:string, []}} -> :ok
      {{:string, []}, {:list, [b]}} ->
        do_compare({:type, 0, :integer, []}, b, m1, m2)
      {{:integer, []}, {:float, []}} -> :ok
      {{:integer, []}, {:neg_integer, []}} -> :ok
      {{:integer, []}, {:pos_integer, []}} -> :ok
      _ ->
        {:error, "type #{gen_spec t1, m1} is not a subtype of #{gen_spec t2, m2}"}
    end
  end
  def gen_elixir({{name, _}, [spec]}, _mod) do
    Kernel.Typespec.spec_to_ast(name, spec)
    |> Macro.to_string()
  end

  def gen_elm({{name, _arity}, [{:type, _ , :bounded_fun, [spec | _constraint]}]}, mod) do
    "#{to_string name} : " <> gen_spec(spec, mod)
  end
  def gen_elm({{name, _arity}, [{:type, _ , :fun, [args , result]}]}, mod) do
    "#{to_string name} : " <>
    gen_spec(args, mod) <> " -> " <>
    gen_spec(result, mod)
  end
  def gen_elm({{name, _arity}, specs}, mod) do
    "#{to_string name} : " <>
    Enum.join(Enum.map(specs, &gen_spec(&1, mod)), " | ")
  end
  def gen_elm({{:erts_internal, name, arity}, specs}, mod) do
    gen_elm({{name, arity}, specs}, mod)
  end
  def gen_elm({{:erlang, name, arity}, specs}, mod) do
    gen_elm({{name, arity}, specs}, mod)
  end

  defp gen_spec({:type, _line, type, args}, mod) do
    case {type, args} do
      {:fun, [args, result]} ->
        "(#{gen_spec args, mod} -> #{gen_spec result, mod})"
      {:product, args} ->
        (args
        |> Enum.map(&gen_spec(&1, mod))
        |> Enum.join(" -> "))
      {:union, args} ->
        args
        |> Enum.map(&gen_spec(&1, mod))
        |> Enum.join(" | ")
      {any, args} when is_list args ->
        "#{elmify_type any, Enum.map(args, &gen_spec(&1, mod))}"
      {any, arg} ->
        elmify_type(any, [arg])
    end
  end
  defp gen_spec({:user_type, _line, name, _args}, mod),
    do: resolve_type(name, mod) |> gen_spec(mod)
  defp gen_spec({:ann_type, _line, [_typename, type]}, mod),
   do: gen_spec(type, mod)
  defp gen_spec({:remote_type, _line, path}, mod) do
    {module, name} = get_path_and_name(path)
    resolve_type(name, module) |> gen_spec(mod)
  end
  defp gen_spec([], _mod), do: "[]"

  defp gen_spec({type, _line, value}, _mod) do
    elmify_type(type, [value])
  end
  defp gen_spec([{:type, _, :constraint, _} | _], _) do
    ""
  end

  defp get_path_and_name(ast) when is_list(ast) do
    rev = Enum.reverse(ast) |> List.flatten
    [{:atom, _, name} | revpath] = rev
    path =
      revpath
      |> Enum.map(fn {:atom, _, module} -> module end)

    path =
      if (length(path) == 1) && !(path |> hd |> to_string |> String.starts_with?("Elixir.")) do
        path |> hd
      else
        Module.concat(path)
      end
    {path, name}
  end
  defp extract_path({:atom, _, name}), do: name


  defp elmify_type(type, rest) do
    case {type, rest} do
      {:map, []} -> "(Map #{rest})"
      {:map, [h | _t] = types} ->
        if is_binary(h) && h |> String.contains?("=") do
          "{" <> Enum.join(types, ",") <> ""
        else
          "Map #{h}"
        end

      {:tuple, _} -> "(#{Enum.join(rest, ", ")})"
      {:pos_integer, []} -> "PositiveInt"
      {:atom, []} -> "Atom"
      {:atom, [val]} -> "Atom #{val}"
      {:boolean, []} -> "Bool"
      {:module, []} -> "Module"
      {:term, []} -> "any"
      {:list, []} -> "List any"
      {:list, _} -> "List " <> Enum.join(rest, " ")
      {:nonempty_maybe_improper_list, [content, _termination]} -> "NonemptyList #{content}"
      {:any, []} -> "any"
      {:timeout, []} -> "Timeout"
      {:no_return, []} -> "()"
      {:byte, []} -> "Byte"
      {:integer, []} -> "Int"
      {:integer, [value]} -> "Int #{value}"
      {:arity, []} -> "Int"
      {:string, []} -> "List Int"
      {:node, []} -> "Atom"
      {:nil, []} -> "Nothing"
      {:pid, []} -> "Pid"
      {:nonempty_string, []} -> "String"
      {:non_neg_integer, []} -> "Int"
      {:binary, []} -> "String"
      {:binary, _any} -> "String"
      {:var, [:_]} -> "a"
      {:var, [name]} -> "#{String.downcase (to_string name)}"
      {:nonempty_list, [type]} -> "List " <> type
      {:record, [type]} -> "Record " <> to_string type
      {:function, []} -> "(Any -> Any)"
      {:fun, []} -> "(Any -> Any)"
      {:bounded_fun, rest} -> Enum.join rest
      {:char, []} -> "Char"
      {:map_field_exact, [key, value]} -> "#{key} = #{value}"
      {:iolist, []} -> "IOList"
      {:iodata, []} -> "IOData"
      {:map_field_assoc, [key, val]} -> "MapFieldAssoc #{key} #{val}"
      {:neg_integer, _} -> "NegativeInt"
      {:float, []} -> "Float"
      {:reference, []} -> "Reference"
      {:bitstring, []} -> "String"
      {:port, []} -> "Port"
      {:number, []} -> "Float"
      {:maybe_improper_list, []} -> "List"
      {:range, [from, to]} -> "Range #{from} #{to}"
      {:type, [:any]} -> "Any"
      {:identifier, []} -> "Int"
      # {:nonempty_list}
    end
  end

  defp resolve_type(type, module) when is_atom(type) do
    beam_types =
      module
      |> Kernel.Typespec.beam_types()

    if beam_types == nil do
      throw "There is no #{type} in #{module}"
    end
    resolved =
      beam_types
      |> Enum.find(fn {:type, {name, _definition, []}} -> name == type end)
    case resolved do
      {:type, {^type, {:type, _, :any, []}, []}} ->
        Logger.debug "Resolved #{inspect type} into itself"
        {:var, 0, type}
      {:type, {^type, definition, []}} ->
        Logger.debug "Resolved #{inspect type} into #{inspect definition}"
        definition
      nil ->
        Logger.warn "No type with name #{type} in module #{module}. Resolving to :any"
        {:type, 0, :any, []}
    end
  end
end
defmodule Elmchemy.SpecError do
  defexception [:message]
end
