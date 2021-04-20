defmodule TripCalculator do
  @moduledoc """
  This module is for sorting Drivers and calculating trip information.
  """

  @spec get_driver_data(binary) :: list
  def get_driver_data(content) do
    content
    |> sort_and_calculate()
  end

  defp sort_and_calculate(content) do
    content
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, " ") end)
    |> driver_or_trip()
  end

  defp driver_or_trip(content) do
    content
    |> Enum.reject(fn entry -> entry == [""] end)
    |> Enum.reduce([], fn entry, acc ->
      case List.first(entry) do
        "Driver" ->
          create_driver(entry, acc)

        "Trip" ->
          calculate_trip(entry, acc)

        _ ->
          [IO.puts("Error: #{entry}")]
      end
    end)
  end

  defp create_driver(new_driver, acc) do
    name = Enum.at(new_driver, 1)
    [%{name: name, distance: [], time: [], average_speed: 0} | acc]
  end

  # Iterates over maps in list created in driver_or_trip/1 to match trip with driver
  defp calculate_trip(new_trip, acc) do
    name = Enum.at(new_trip, 1)
    start_time = Enum.at(new_trip, 2)
    end_time = Enum.at(new_trip, 3)

    distance =
      Enum.at(new_trip, 4)
      |> String.to_float()

    time = calculate_time_in_hours(start_time, end_time)
    mph = calculate_mph(time, distance)

    Enum.map(acc, fn driver_data ->
      if driver_data && driver_data.name == name do
        new_distance =
          if not is_nil(mph) do
            [distance | driver_data.distance]
          else
            driver_data.distance
          end

        new_time =
          if not is_nil(mph) do
            [time | driver_data.time]
          else
            driver_data.time
          end

        driver_data = %{driver_data | distance: new_distance}
        driver_data = %{driver_data | time: new_time}
        driver_data
      else
        driver_data
      end
    end)
  end

  # Returns time in hours between start of trip and end of trip
  defp calculate_time_in_hours(start_time, end_time) do
    [start_hours, start_minutes] = String.split(start_time, ":")
    start_time = Time.new!(String.to_integer(start_hours), String.to_integer(start_minutes), 0, 0)

    [end_hours, end_minutes] = String.split(end_time, ":")
    end_time = Time.new!(String.to_integer(end_hours), String.to_integer(end_minutes), 0, 0)

    seconds = Time.diff(end_time, start_time, :second)
    seconds / 60 / 60
  end

  # Calculates mph, returns nil if mph falls outside set parameter,
  # or mph if not. The return is used to reject trips that fall outside the parameters.
  defp calculate_mph(time, distance) do
    mph = distance / time

    cond do
      mph > 100 ->
        nil

      mph < 5 ->
        nil

      true ->
        mph
    end
  end
end
