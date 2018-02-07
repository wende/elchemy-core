defmodule Elchemy.Elixir.NativePlugin do

  alias Elchemy.Elixir.NativeAst

  @spec encode_module_name(String.t, term()) :: String.t
  def encode_module_name(name, ast) do
    hash_id = ast |> :erlang.term_to_binary() |> :erlang.crc32 |> Integer.to_string(32)
    :"Elixir.Elchemy.Plugins.#{name}.H#{hash_id}"
  end

  def defplugin(%{setup: setup, ast: ast, name: name}) do
    module_name = encode_module_name(name, ast)

    setups = for line <- setup do
      {:ok, quoted} = Code.string_to_quoted(line)
      quoted
    end

    serialized_ast = for statement <- ast do
      NativeAst.serialize(statement)
    end

    quote do
      defmodule unquote(module_name) do
        unquote(setups)
        unquote(serialized_ast)
      end
    end |> Code.eval_quoted()
  end
end
