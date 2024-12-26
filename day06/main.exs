defmodule Main do
  @file_path "./input.txt"

  @barrier ?\#
  @empty ?.
  @guard_char ?^
  @guard_direction {-1, 0}

  def call do
    board = read_file()

    guard = Enum.find(board, fn {_pos, dir} -> @guard_direction == dir end)

    visited = process_part1(board, guard)

    IO.puts("part1: #{MapSet.size(visited)}")

    :persistent_term.put(__MODULE__, {board, guard})

    visited
    |> MapSet.delete(elem(guard, 0))
    |> process_part2()
    |> then(&IO.puts("part2: #{&1}"))
  end

  defp read_file do
    @file_path
    |> File.stream!()
    |> Stream.with_index()
    |> Stream.flat_map(fn {line, row} ->
      line
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.map(fn
        {@guard_char, column} ->
          {{row, column}, @guard_direction}

        {mark, column} ->
          {{row, column}, mark}
      end)
    end)
    |> Map.new()
  end

  defp process_part1(board, guard) do
    update_board(board, guard, MapSet.new([]))
  end

  defp process_part2(visited) do
    visited
    |> Task.async_stream(
      fn pos ->
        {board, guard} = :persistent_term.get(__MODULE__)

        board = Map.put(board, pos, @barrier)

        brent_cycle_detection_algorithm(guard, board)
      end,
      ordered: false,
      timeout: :infinity
    )
    |> Enum.count(fn {:ok, result} -> result end)
  end

  defp update_board(board, guard, visited) do
    {pos, _direction} = guard
    visited = MapSet.put(visited, pos)

    case move_guard(guard, board) do
      nil ->
        visited

      guard ->
        update_board(board, guard, visited)
    end
  end

  defp move_guard(nil, _board), do: nil

  defp move_guard({pos, dir} = _guard, board) do
    next = add(pos, dir)

    case board do
      %{^next => mark} when mark in [@empty, @guard_direction] ->
        {next, dir}

      %{^next => @barrier} ->
        move_guard({pos, rotate90(dir)}, board)

      %{} ->
        nil
    end
  end

  defp add({a, b}, {c, d}), do: {a + c, b + d}

  defp rotate90({a, b}), do: {b, -a}

  defp brent_cycle_detection_algorithm(guard, board) do
    power = lam = 1
    tortoise = guard
    hare = move_guard(guard, board)
    cycle?(board, tortoise, hare, power, lam)
  end

  defp cycle?(_board, _tortoise, nil, _power, _lam), do: false
  defp cycle?(_board, hare, hare, _power, _lam), do: true

  defp cycle?(board, _tortoise, hare, power, power),
    do: cycle?(board, hare, move_guard(hare, board), power * 2, 0)

  defp cycle?(board, tortoise, hare, power, lam),
    do: cycle?(board, tortoise, move_guard(hare, board), power, lam + 1)
end

Main.call()
