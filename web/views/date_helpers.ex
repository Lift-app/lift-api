defmodule Lift.DateHelpers do
  @moduledoc """
  Helper for formatting dates in the correct timezone
  """
  use Timex

  @doc """
  Convert a UTC datetime to use local timezone
  """
  def local_date(datetime) do
    Timezone.convert(datetime, Application.get_env(:lift, :timezone))
  end
end
