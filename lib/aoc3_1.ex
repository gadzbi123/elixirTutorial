defmodule AOC3_1 do
  def parseInput do
    File.read!("../files/3.input")
    |> String.split(",")
    |> Enum.map(fn
      "R" <> n -> {:r, String.to_integer(n)}
      "L" <> n -> {:l, String.to_integer(n)}
      "U" <> n -> {:u, String.to_integer(n)}
      "D" <> n -> {:d, String.to_integer(n)}
    end)

    # |> Enum.reduce([{0,0}],&add_points/2)
  end

  def add_point() do
  end

  #   def parseValue(v) do
  #     case v do
  #       [l | n] -> %{dir: String.to_existing_atom(l), amount: String.to_integer(n)}
  #     end
  #   end
end
