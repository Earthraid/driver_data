defmodule TripCalculatorTest do
  import ExUnit.CaptureIO
  use ExUnit.Case
  doctest TripCalculator
  alias TripCalculator

  test "correctly sorts drivers" do
    mock_data =
      "Driver Dan\nDriver Lauren\nDriver Kumi\nTrip Dan 07:15 07:45 17.3\nTrip Dan 06:12 06:32 21.8\nTrip Lauren 12:01 13:16 42.0"

    assert TripCalculator.get_driver_data(mock_data) ==
             [
               %{average_speed: 0, distance: [], name: "Kumi", time: []},
               %{average_speed: 0, distance: [42.0], name: "Lauren", time: [1.25]},
               %{
                 average_speed: 0,
                 distance: [21.8, 17.3],
                 name: "Dan",
                 time: [0.3333333333333333, 0.5]
               }
             ]
  end

  test "empty file imported" do
    mock_data = ""

    assert TripCalculator.get_driver_data(mock_data) == []
  end

  test "garbage file imported" do
    mock_data = "<definitely not malicious>"

    result = fn ->
      assert Enum.each(TripCalculator.get_driver_data(mock_data), &IO.puts(&1)) == :ok
    end

    assert capture_io(result) =~ "Error: <definitelynotmalicious>"
  end
end
