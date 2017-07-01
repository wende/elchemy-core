
# Compiled using Elmchemy v0.3.33
defmodule Elmchemy.XDebug do
  use Elmchemy

  @doc """
  Module with helper functions for debugging
  
  
  # Debug
  
  @docs log, crash
  
  
 
  """
  import Elmchemy
  @doc """
  Log to console in `title: object` format
  
 
  """
  @spec log(String.t, any) :: any
  curry log/2
  def log(title, a) do
    _ = puts_.("#{title}:#{a}").([])
    a
  end

  @spec puts_(any, list({any, any})) :: any
  curryp puts_/2
  verify as: IO.inspect/2
  def puts_(a1, a2), do: IO.inspect(a1, a2)
  #  We don't verify since it's a macro 
  @doc """
  Raise an exception to crash the runtime. Should be avoided at all
  costs. Helpful for crashing at not yet implelented functionality
  
 
  """
  @spec crash(String.t) :: any
  curry crash/1
  def crash(a1), do: Kernel.raise(a1)
end
