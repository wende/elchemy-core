defmodule ExUxunitPluginTest do
  use Elchemy
  use ExUnit.Case

  require Elchemy.Plugins.ExUnit, as: ExUnitPlugin

  ExUnitPlugin.test(Elchemy.Tests.ExUnitTest.Meta)

end
