defmodule AOC2 do
  def solve1() do
    File.stream!("./files/2025_2.input")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn line_arr -> Enum.map(line_arr, &String.to_integer/1) end)
    |> Enum.reduce([], fn line, acc ->
      chunks = Enum.chunk_every(line, 2, 1, :discard)

      if chunks_in_range(chunks) do
        [line | acc]
      else
        acc
      end
    end)
    |> Enum.count()
  end

  def chunk_in_range([a, b]) do
    abs(a - b) >= 1 and abs(a - b) <= 3
  end

  def in_same_dir?(list) do
    all_negative = Enum.all?(list, fn [a, b] -> a - b < 0 end)
    all_positive = Enum.all?(list, fn [a, b] -> a - b > 0 end)
    all_negative || all_positive
  end

  def chunks_in_range(chunks) do
    Enum.all?(chunks, &chunk_in_range/1) and in_same_dir?(chunks)
  end

  def solve2() do
    File.stream!("./files/2025_2.input")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn line_arr -> Enum.map(line_arr, &String.to_integer/1) end)
    |> Enum.reduce([], fn line, acc ->
      with true <- is_safe?(line) do
        [line | acc]
      else
        false -> acc
      end
    end)
    |> Enum.count()
  end

  def is_safe?(list) when length(list) <= 1, do: true

  def is_safe?(list) do
    is_safe_without_removal?(list) || can_be_safe_with_removal?(list)
  end

  defp is_safe_without_removal?(list) do
    with true <- check_direction(list),
         true <- check_differences(list) do
      true
    else
      false -> false
    end
  end

  defp can_be_safe_with_removal?(list) do
    0..(length(list) - 1)
    |> Enum.any?(fn i ->
      removed = List.delete_at(list, i)
      is_safe_without_removal?(removed)
    end)
  end

  defp check_direction([_]), do: true

  defp check_direction(list) do
    differences = get_differences(list)
    all_positive = Enum.all?(differences, &(&1 > 0))
    all_negative = Enum.all?(differences, &(&1 < 0))
    all_positive || all_negative
  end

  defp check_differences(list) do
    differences = get_differences(list)
    Enum.all?(differences, &(abs(&1) >= 1 and abs(&1) <= 3))
  end

  defp get_differences(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
  end
end

AOC2.solve1() |> IO.inspect()
AOC2.solve2() |> IO.inspect()
