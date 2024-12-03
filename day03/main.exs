defmodule Main do
  @file_path "./input.txt"
  @regex_part1 ~r"mul\((\d{1,3}),(\d{1,3})\)"
  @regex_part2 ~r"do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)"

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
    |> File.read!()
    |> String.trim()
  end

  defp process_part1(file_content) do
    @regex_part1
    |> Regex.scan(file_content)
    |> Enum.map(fn [_match, num1, num2] ->
      String.to_integer(num1) * String.to_integer(num2)
    end)
    |> Enum.sum()
  end

  defp process_part2(file_content) do
    @regex_part2
    |> Regex.scan(file_content)
    |> Enum.reduce({true, 0}, fn
      ["do()"], {_enabled, sum} ->
        {true, sum}

      ["don't()"], {_enabled, sum} ->
        {false, sum}

      [_match, num1, num2], {true, sum} ->
        partial_sum = String.to_integer(num1) * String.to_integer(num2)
        {true, partial_sum + sum}

      _else, {false, sum} ->
        {false, sum}
    end)
    |> elem(1)
  end
end

Main.call()
