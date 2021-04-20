defmodule DriverData do
  alias IngestFile, as: Input
  alias Output
  alias TripCalculator, as: Calc

  @moduledoc """
  This module is meant to be used by `Main` to communicate with `IngestFile`, `TripCalculator`, and `Output`.
  """

  def process_file() do
    case Input.ingest_file() do
      {:ok, content} ->
        content
        |> calculate_data()
        |> print_report()

      {:error, reason} ->
        IO.puts(reason)
    end
  end

  defp calculate_data(content) do
    Calc.get_driver_data(content)
  end

  defp print_report(content) do
    Output.prepare_and_print_report(content)
  end
end
