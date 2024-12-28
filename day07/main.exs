defmodule Main do
  @file_path "./input.txt"
  @operators ~w(+ *)

  def call do
    calibrations = read_file()

    process_part1(calibrations)
  end

  defp read_file do
    @file_path
    |> File.stream!()
    |> Enum.map(fn line ->
      [test, rest] = String.split(line, ":", tirm: true)

      numbers =
        rest
        |> String.replace("\n", "")
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)

      {String.to_integer(test), numbers}
    end)
  end

  defp process_part1(calibrations) do
    calibrations
    |> Enum.map(fn {_test, numbers} ->
      n = length(numbers) - 1 |> dbg()
      combinations(@operators, n) |> dbg()
    end)
  end

  defp combinations(list, num)
  defp combinations(_list, 0), do: [[]]
  defp combinations(list = [], _num), do: list

  defp combinations([head | tail], num) do
    Enum.map(combinations(tail, num - 1), &[head | &1]) ++
      combinations(tail, num)
  end
end

Main.call()
