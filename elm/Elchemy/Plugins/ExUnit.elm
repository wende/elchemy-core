module Elchemy.Plugins.ExUnit exposing (..)

import Elchemy exposing (..)
import Elchemy.Macros exposing (..)


{- ex
   defmacro test(mod) do
        {mod, []} = Code.eval_quoted(mod)
        mod.tests()
   end
   def define_tests(tests) do
        {%{
            name: suite_name,
            initial_value: initial_value,
            setup_all: {:setup, setup_all_f},
            setup: {:setup, setup_f},
            tests: tests
        }, []} = Code.eval_quoted(tests)
        inner =
          for {:test, name, f} <- tests do
              body = f |> IO.inspect
              quote do
                  test unquote(name), %{context: context} do
                      assert unquote(body).(context)
                 end
              end
          end

        tests_def =
            quote do
                setup_all do
                    %{context: unquote(setup_all_f).(unquote(initial_value))}
                end
                describe unquote(suite_name) do
                    setup %{context: context} do
                        %{context: unquote(setup_f).(context)}
                    end
                    unquote(inner)
                end
            end |> Macro.escape
        quote do
            def tests() do
                unquote(tests_def)
            end
        end
   end
-}


type Test c
    = Test String (Do (c -> Bool))


type Setup c1 c2
    = Setup (Do (c1 -> c2))


type alias Suite initialContext context testContext =
    { name : String
    , initialValue : initialContext
    , setupAll : Setup initialContext context
    , setup : Setup context testContext
    , tests : List (Test testContext)
    }


suite : String -> c -> Suite c c c
suite name initialValue =
    { name = name
    , initialValue = initialValue
    , setupAll = Setup (Do <| \a -> a)
    , setup = Setup (Do <| \a -> a)
    , tests = []
    }


tests : Suite c1 c2 c3 -> Macro
tests =
    macro "Elchemy.Plugins.ExUnit" "define_tests"


test : String -> Do (c3 -> Bool) -> Suite c1 c2 c3 -> Suite c1 c2 c3
test name f suite =
    { suite | tests = Test name f :: suite.tests }


setup : Do (c2 -> c3) -> Suite c1 c2 c3 -> Suite c1 c2 c3
setup f suite =
    { suite | setup = Setup f }


setupAll : Do (c1 -> c2) -> Suite c1 c2 c3 -> Suite c1 c2 c3
setupAll f suite =
    { suite | setupAll = Setup f }
