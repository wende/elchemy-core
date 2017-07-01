
# Compiled using Elmchemy v0.3.33
defmodule Elmchemy.XDate do
  use Elmchemy

  @doc """
  Library for working with dates. Email the mailing list if you encounter
  issues with internationalization or locale formatting.
  
  
  # Dates
  
  @docs Date, now
  
  
  # Conversions
  
  @docs fromString, toTime, fromTime
  
  
  # Extractions
  
  @docs year, month, Month, day, dayOfWeek, Day, hour, minute, second, millisecond
  
  
 
  """
  import Task, only: []
  import Time, only: []
  import XResult, only: []
  @doc """
  Representation of a date.
  
 
  """
  @type date :: :date

  @doc """
  Get the `Date` at the moment when this task is run.
  
 
  """
  @spec now() :: {:task, any, date}
  def now() do
    Task.map.(from_time).(Time.now)
  end

  @doc """
  Represents the days of the week.
  
 
  """
  @type day :: :mon | :tue | :wed | :thu | :fri | :sat | :sun

  @doc """
  Represents the month of the year.
  
 
  """
  @type month :: :jan | :feb | :mar | :apr | :may | :jun | :jul | :aug | :sep | :oct | :nov | :dec

  @doc """
  Attempt to read a date from a string.
  
 
  """
  @spec from_string(String.t) :: Elmchemy.XResult.result
  curry from_string/1
  verify as: XDate.fromString/1
  def from_string(a1), do: XDate.fromString(a1)
  @doc """
  Convert a `Date` to a time in milliseconds.
  
  A time is the number of milliseconds since
  [the Unix epoch](http://en.wikipedia.org/wiki/Unix_time).
  
  
 
  """
  @spec to_time(date) :: :time
  curry to_time/1
  verify as: XDate.toTime/1
  def to_time(a1), do: XDate.toTime(a1)
  @doc """
  Convert a time in milliseconds into a `Date`.
  
  A time is the number of milliseconds since
  [the Unix epoch](http://en.wikipedia.org/wiki/Unix_time).
  
  
 
  """
  @spec from_time(:time) :: date
  curry from_time/1
  verify as: XDate.fromTime/1
  def from_time(a1), do: XDate.fromTime(a1)
  @doc """
  Extract the year of a given date. Given the date 23 June 1990 at 11:45AM
  this returns the integer `1990`.
  
 
  """
  @spec year(date) :: integer
  curry year/1
  verify as: XDate.year/1
  def year(a1), do: XDate.year(a1)
  @doc """
  Extract the month of a given date. Given the date 23 June 1990 at 11:45AM
  this returns the month `Jun` as defined below.
  
 
  """
  @spec month(date) :: month
  curry month/1
  verify as: XDate.month/1
  def month(a1), do: XDate.month(a1)
  @doc """
  Extract the day of a given date. Given the date 23 June 1990 at 11:45AM
  this returns the integer `23`.
  
 
  """
  @spec day(date) :: integer
  curry day/1
  verify as: XDate.day/1
  def day(a1), do: XDate.day(a1)
  @doc """
  Extract the day of the week for a given date. Given the date 23 June
  1990 at 11:45AM this returns the day `Sat` as defined below.
  
 
  """
  @spec day_of_week(date) :: day
  curry day_of_week/1
  verify as: XDate.dayOfWeek/1
  def day_of_week(a1), do: XDate.dayOfWeek(a1)
  @doc """
  Extract the hour of a given date. Given the date 23 June 1990 at 11:45AM
  this returns the integer `11`.
  
 
  """
  @spec hour(date) :: integer
  curry hour/1
  verify as: XDate.hour/1
  def hour(a1), do: XDate.hour(a1)
  @doc """
  Extract the minute of a given date. Given the date 23 June 1990 at 11:45AM
  this returns the integer `45`.
  
 
  """
  @spec minute(date) :: integer
  curry minute/1
  verify as: XDate.minute/1
  def minute(a1), do: XDate.minute(a1)
  @doc """
  Extract the second of a given date. Given the date 23 June 1990 at 11:45AM
  this returns the integer `0`.
  
 
  """
  @spec second(date) :: integer
  curry second/1
  verify as: XDate.second/1
  def second(a1), do: XDate.second(a1)
  @doc """
  Extract the millisecond of a given date. Given the date 23 June 1990 at 11:45:30.123AM
  this returns the integer `123`.
  
 
  """
  @spec millisecond(date) :: integer
  curry millisecond/1
  verify as: XDate.millisecond/1
  def millisecond(a1), do: XDate.millisecond(a1)
end
