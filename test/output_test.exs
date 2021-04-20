defmodule OutputTest do
  import ExUnit.CaptureIO
  use ExUnit.Case
  doctest Output
  alias Output

  test "correctly sorts drivers" do
    mock_data = [
      %{average_speed: 0, distance: [], name: "Kumi", time: []},
      %{average_speed: 0, distance: [42.0], name: "Lauren", time: [1.25]},
      %{average_speed: 0, distance: [21.8, 17.3], name: "Dan", time: [0.33, 0.5]}
    ]

    result = fn ->
      assert Enum.each(Output.prepare_and_print_report(mock_data), &IO.puts(&1)) == :ok
    end

    assert capture_io(result) =~ "Lauren: 42 miles @ 34 mph"
    assert capture_io(result) =~ "Dan: 39 miles @ 47 mph"
    assert capture_io(result) =~ "Kumi: 0 miles"
  end

  test "empty list" do
    mock_data = []

    result = fn ->
      assert Enum.each(Output.prepare_and_print_report(mock_data), &IO.puts(&1)) == :ok
    end

    assert capture_io(result) == ""
  end
end
