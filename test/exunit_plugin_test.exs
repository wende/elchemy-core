defmodule ExUxunitPluginTest do
  use Elchemy
  use ExUnit.Case

  alias Elchemy.Elixir.Plugin
  alias Elchemy.Elixir.NativePlugin

  doctest Plugin
  typetest Plugin

  test "Can create a plug" do
    serialize = fn {:block, "@" <> name} ->
      {:application, (atom "def"), [
        {:application, (atom "test2"), []},
        {:do, [{:application, (atom "@"), [{:variable, name}]}]}
      ]}

    end

    compiled = Plugin.compile(%{
      name: "MyTestPlugin",
      setup: ["@myattribute 1", "def test, do: @myattribute"],
      blocks: [{:block, "@myattribute"}],
      serialize: serialize
    })

    {{:module, mod, _, _}, _} = NativePlugin.defplugin(compiled)
    assert mod.test() == 1
    assert mod.test2() == 1
  end

  defp atom(x), do: {:value, {:atom, x}}
  defp int(x), do: {:value, {:int, x}}

end
