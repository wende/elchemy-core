defmodule ExUxunitPluginTest do
  use Elchemy
  use ExUnit.Case

  alias Elchemy.Elixir.Plugin
  alias Elchemy.Elixir.NativePlugin
  require Elchemy.Plugins.ExUnit, as: ExUnitPlugin

  doctest Plugin
  typetest Plugin

  ExUnitPlugin.test(Elchemy.Tests.ExUnitTest.Meta)

end
