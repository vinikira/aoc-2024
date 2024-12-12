defmodule Main do
  @file_path "./input.txt"

  def call do
    rules_and_updates = read_file()

    rules_and_updates
    |> process_part1()
    |> then(&IO.puts("part1: #{&1}"))

    rules_and_updates
    |> process_part2()
    |> then(&IO.puts("part2: #{&1}"))
  end

  defp read_file do
    [rules_str, updates_str] =
      @file_path
      |> File.read!()
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    rules =
      rules_str
      |> Enum.map(fn rule_str -> String.split(rule_str, "|", trim: true) end)
      |> Enum.group_by(
        fn [n1, _n2] -> String.to_integer(n1) end,
        fn [_n1, n2] -> String.to_integer(n2) end
      )

    updates =
      Enum.map(updates_str, fn update_str ->
        update_str
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end

  defp process_part1({rules, updates}) do
    Enum.reduce(updates, [], fn update, acc ->
      if valid?(update, rules) do
        [update | acc]
      else
        acc
      end
    end)
    |> Enum.reverse()
    |> Enum.map(fn updates ->
      middle = floor(length(updates) / 2)
      Enum.at(updates, middle)
    end)
    |> Enum.sum()
  end

  defp process_part2({rules, updates}) do
    updates
    |> Enum.reject(&valid?(&1, rules))
    |> Enum.map(fn update ->
      sorted_update =
        Enum.sort_by(update, &Function.identity/1, fn ls, rs ->
          rule = Map.get(rules, ls)

          rs not in rule
        end)

      middle = floor(length(sorted_update) / 2)
      Enum.at(sorted_update, middle)
    end)
    |> Enum.sum()
  end

  defp valid?(update, rules) do
    update
    |> Enum.reduce_while({[], true}, fn update_number, {acc2, _valid?} ->
      rule = Map.get(rules, update_number)

      if Enum.all?(rule, fn n -> n not in acc2 end) do
        {:cont, {[update_number | acc2], true}}
      else
        {:halt, {acc2, false}}
      end
    end)
    |> elem(1)
  end
end

Main.call()
