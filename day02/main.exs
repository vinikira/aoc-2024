defmodule Main do
  @file_path "./input.txt"
  @separator " "

  def call do
    reports = read_file()

    reports
    |> process_part1()
    |> then(&IO.puts("part1: #{&1}"))

    reports
    |> process_part2()
    |> then(&IO.puts("part2: #{&1}"))
  end

  defp read_file do
    @file_path
    |> File.stream!()
    |> Stream.map(fn line ->
      line
      |> String.trim()
      |> String.split(@separator)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp process_part1(reports) do
    Enum.count(reports, fn report ->
      report
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [n, m] -> n - m end)
      |> Enum.into(MapSet.new())
      |> safe?()
    end)
  end

  defp safe?(result) do
    MapSet.size(MapSet.difference(result, MapSet.new([1, 2, 3]))) == 0 or
      MapSet.size(MapSet.difference(result, MapSet.new([-1, -2, -3]))) == 0
  end

  defp process_part2(reports) do
    Enum.count(reports, fn report ->
      Enum.any?(0..length(report), fn index ->
        report
        |> List.delete_at(index)
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [n, m] -> n - m end)
        |> Enum.into(MapSet.new())
        |> safe?()
      end)
    end)
  end
end

Main.call()
