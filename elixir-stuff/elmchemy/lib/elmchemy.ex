defmodule ElmchemyHack do
  defmacro __before_compile__(_env) do
    module = __CALLER__.module
    verifies = Macro.escape(Module.get_attribute(module, :verify_type))
    quote do
      def __type_tests__ do
        unquote(verifies)
      end
    end
  end
end

defmodule Elmchemy do
  defmacro __using__(_) do
    quote do
      Module.register_attribute(__MODULE__, :verify_type, accumulate: true)
      @before_compile ElmchemyHack

      require Elmchemy
      require Elmchemy.Glue

      import Elmchemy
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
