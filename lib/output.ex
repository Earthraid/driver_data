defmodule Output do
  @moduledoc """
  This module is for preparing and printing the final report data.
  """

  def prepare_and_print_report(driver_data) do
    driver_data
    |> Enum.reduce([], fn %{name: name, time: time, distance: distance, average_speed: _}, acc ->
      total_distance = sum_distance(distance)
      time = sum_time(time)
      average_speed = average_speed(%{distance: total_distance, time: time})
      [%{name: name, average_speed: average_speed, distance: total_distance} | acc]
    end)
    |> sort_by_milage()
    |> print_report()
  end

  defp average_speed(%{distance: total_distance, time: total_time}) do
    if total_time != 0 do
      (total_distance / total_time)
      |> Float.round()
      |> trunc()
    else
      0
    end
  end

  defp print_report(report) when is_list(report) do
    report
    |> Stream.map(fn %{name: name, average_speed: average_speed, distance: distance} ->
      if distance != 0 do
        IO.puts("#{name}: #{distance} miles @ #{average_speed} mph")
      else
        IO.puts("#{name}: #{distance} miles")
      end
    end)
  end

  defp sort_by_milage(driver_data) do
    Enum.sort_by(driver_data, fn data -> data.distance end, :desc)
  end

  defp sum_distance(distance) when is_list(distance) do
    if distance != [] do
      Enum.sum(distance) |> trunc()
    else
      0
    end
  end

  defp sum_time(time) when is_list(time) do
    if time != [] do
      Enum.sum(time)
    else
      0
    end
  end
end
