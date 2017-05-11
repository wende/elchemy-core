defmodule ElmchemyHack do

  defp get_definitions(content) do
    ~r/def (\w+)/
    |> Regex.scan(content)
  end

  defmacro __before_compile__(env) do
    IO.inspect env
    IO.inspect __CALLER__.module

    File.read!(env.file)
    |> IO.inspect
    |> get_definitions
    |> IO.inspect
  end

end

defmodule Elmchemy do

  defmacro __using__(_) do
    quote do
      require Elmchemy
      import Elmchemy
      require Elmchemy.Glue

      import Kernel, except: [{:"++", 2}]

      import Elmchemy.Glue
      import Kernel, except: [
        {:'++', 2}
      ]
      alias Elmchemy.{
        XBasics,
        XList,
        XString,
        XMaybe,
        XChar,
        XTuple,
        XResult
      }
      import_std()
    end
  end

  @std [
    Elmchemy.XBasics,
    Elmchemy.XList,
    Elmchemy.XString,
    Elmchemy.XMaybe,
    Elmchemy.XChar,
    Elmchemy.XTuple,
    Elmchemy.XResult
    ]
  defmacro import_std() do
    if Enum.member?(@std, __CALLER__.module) do
      quote do
        :ok
      end
    else
      quote do
        import Elmchemy.XBasics
        import Elmchemy.XList, only: [{:cons, 0}]
        # Rest contains no functions
        # import Maybe exposing ( Maybe( Just, Nothing ) )
        # import Result exposing ( Result( Ok, Err ) )
        # import String
        # import Tuple
        # import Debug
      end
    end
  end
end
