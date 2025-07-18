defmodule Aoc3 do
  def solve1() do
    File.stream!("./files/2025_3.input")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&find_parts/1)
    |> Enum.to_list()
    |> List.flatten()
    |> Enum.sum()
  end

  def find_parts(str) do
    Regex.scan(~r/mul\((?<v1>\d{1,3}),(?<v2>\d{1,3})\)/, str, capture: :all_names)
    |> Enum.reduce([], fn [v1, v2], acc ->
      [String.to_integer(v1) * String.to_integer(v2) | acc]
    end)
  end

  def solve2() do
    File.stream!("./files/2025_3.input")
    |> Stream.map(&String.trim/1)
    |> Enum.join()
    |> extract()
    |> apply_operations()
  end

  defp extract(str) do
    ~r/mul\(\d+,\d+\)|do\(\)|don\'t\(\)/
    |> Regex.scan(str)
    |> Enum.map(&hd/1)
  end

  defp apply_operations(op) do
    op |> Enum.reduce({0, true}, &apply_operation/2) |> elem(0)
  end

  defp apply_operation(op, {total, can_do}) do
    case {op, can_do} do
      {"do()", _} ->
        {total, true}

      {"don\'t()", _} ->
        {total, false}

      {mul, true} ->
        {apply_multiplication(mul) + total, true}

      {_mul, false} ->
        {total, false}
    end
  end

  defp apply_multiplication(mul_op) do
    ~r/\d{1,3}/
    |> Regex.scan(mul_op)
    |> Enum.flat_map(& &1)
    |> Enum.map(&String.to_integer/1)
    # |> Enum.reduce(1, fn x, acc -> acc * x end)
    |> Enum.product()
  end
end

Aoc3.solve1() |> IO.inspect()
Aoc3.solve2() |> IO.inspect()
