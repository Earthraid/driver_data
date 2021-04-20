defmodule IngestFile do
  @moduledoc """
  This module is for ingesting driver and trip data from a file.
  """
  alias DriverData

  def ingest_file() do
    case IO.read(:stdio, :all) do
      "" ->
        {:error, "Empty file"}

      {:error, reason} ->
        {:error, reason}

      content ->
        {:ok, content}
    end
  end
end
