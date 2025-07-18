defmodule AOC3 do
  @maxint 9_223_372_036_854_775_807
  def solve1() do
    File.stream!("./files/3.input")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(
      # This could be moved to separate function but I don't need it
      &Stream.map(
        &1,
        fn
          "R" <> n -> {:r, String.to_integer(n)}
          "L" <> n -> {:l, String.to_integer(n)}
          "U" <> n -> {:u, String.to_integer(n)}
          "D" <> n -> {:d, String.to_integer(n)}
          "" -> nil
        end
      )
    )
    |> Stream.map(&process_wires/1)
    |> Enum.to_list()
    |> get_smallest_intersection()
  end

  def process_wires(wire) do
    Enum.reduce(wire, {{0, 0}, MapSet.new()}, &get_lines/2)
  end

  def get_lines({dir, n}, {{x, y}, points}) do
    case dir do
      :r ->
        new_line =
          for new_x <- x..(x + n) do
            {new_x, y}
          end

        {{x + n, y}, MapSet.union(points, MapSet.new(new_line))}

      :l ->
        new_line =
          for new_x <- x..(x - n) do
            {new_x, y}
          end

        {{x - n, y}, MapSet.union(points, MapSet.new(new_line))}

      :u ->
        new_line =
          for new_y <- y..(y + n) do
            {x, new_y}
          end

        {{x, y + n}, MapSet.union(points, MapSet.new(new_line))}

      :d ->
        new_line =
          for new_y <- (y - n)..y do
            {x, new_y}
          end

        {{x, y - n}, MapSet.union(points, MapSet.new(new_line))}

      nil ->
        {{x, y}, points}
    end
  end

  def get_smallest_intersection([{_, wire1}, {_, wire2}]) do
    MapSet.intersection(wire1, wire2)
    |> Enum.reduce(@maxint, fn {x, y}, old_point_distance ->
      new_point_distance = abs(x) + abs(y)

      if new_point_distance < old_point_distance and new_point_distance != 0 do
        new_point_distance
      else
        old_point_distance
      end
    end)
  end
end

AOC3.solve1() |> IO.inspect()
