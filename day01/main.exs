defmodule Main do
  @file_path "./input.txt"
  @separator "   "

  def call do
    locations_ids = read_file()

    locations_ids
    |> process_part1()
    |> then(&IO.puts("part1: #{&1}"))

    locations_ids
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
    |> Stream.zip_with(& &1)
  end

  defp process_part1(locations_ids) do
    [ids1, ids2] = Enum.to_list(locations_ids)

    Enum.zip(Enum.sort(ids1), Enum.sort(ids2))
    |> Enum.map(fn {num1, num2} -> abs(num1 - num2) end)
    |> Enum.sum()
  end

  defp process_part2(locations_ids) do
    [ids1, ids2] = Enum.to_list(locations_ids)

    Enum.reduce(ids1, 0, fn id1, acc ->
      acc + id1 * Enum.count(ids2, &(&1 == id1))
    end)
  end
end

Main.call()
