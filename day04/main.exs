defmodule Main do
  @file_path "./input.txt"

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
    |> String.codepoints()
    |> Enum.reduce({%{}, 0, 0}, fn
      "\n", {acc, _x, y} ->
        {acc, 0, y + 1}

      c, {acc, x, y} ->
        {Map.put(acc, {x, y}, c), x + 1, y}
    end)
    |> elem(0)
  end

  defp process_part1(grid) do
    Enum.reduce(grid, [], fn
      {{r, c}, "X"}, acc ->
        [
          for(i <- 0..3, do: Map.get(grid, {r, c + i})),
          for(i <- 0..3, do: Map.get(grid, {r, c - i})),
          for(i <- 0..3, do: Map.get(grid, {r + i, c})),
          for(i <- 0..3, do: Map.get(grid, {r - i, c})),
          for(i <- 0..3, do: Map.get(grid, {r + i, c + i})),
          for(i <- 0..3, do: Map.get(grid, {r + i, c - i})),
          for(i <- 0..3, do: Map.get(grid, {r - i, c + i})),
          for(i <- 0..3, do: Map.get(grid, {r - i, c - i}))
          | acc
        ]

      _not_match, acc ->
        acc
    end)
    |> Enum.count(fn
      ["X", "M", "A", "S"] ->
        true

      _not_match ->
        false
    end)
  end

  defp process_part2(grid) do
    Enum.reduce(grid, [], fn
      {{r, c}, "A"}, acc ->
        [
          [
            [
              Map.get(grid, {r - 1, c - 1}),
              Map.get(grid, {r, c}),
              Map.get(grid, {r + 1, c + 1})
            ],
            [
              Map.get(grid, {r - 1, c + 1}),
              Map.get(grid, {r, c}),
              Map.get(grid, {r + 1, c - 1})
            ]
          ]
          | acc
        ]

      _not_match, acc ->
        acc
    end)
    |> Enum.count(fn
      [["M", "A", "S"], ["M", "A", "S"]] ->
        true

      [["M", "A", "S"], ["S", "A", "M"]] ->
        true

      [["S", "A", "M"], ["S", "A", "M"]] ->
        true

      [["S", "A", "M"], ["M", "A", "S"]] ->
        true

      _not_match ->
        false
    end)
  end
end

Main.call()
