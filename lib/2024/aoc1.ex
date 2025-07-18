defmodule Aoc1 do
  def solve1() do
    File.stream!("./files/2025_1.input")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
    |> Enum.reduce({[], []}, fn {li, ri}, {acc1, acc2} -> {[li | acc1], [ri | acc2]} end)
    |> then(fn {l1, l2} -> {Enum.sort(l1), Enum.sort(l2)} end)
    |> then(fn {l1, l2} -> Enum.zip_with(l1, l2, &abs(&1 - &2)) end)
    |> Enum.sum()
  end

  def solve2() do
    File.stream!("./files/2025_1.input")
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
    |> Enum.reduce({[], %{}}, fn {l, r}, {list, counts} ->
      {[l | list], Map.update(counts, r, 1, fn x -> x + 1 end)}
    end)
    |> then(fn {list, counts} ->
      Enum.reduce(list, 0, fn l, acc -> acc + l * Map.get(counts, l, 0) end)
    end)
  end
end

Aoc1.solve1() |> IO.inspect()
Aoc1.solve2() |> IO.inspect()
