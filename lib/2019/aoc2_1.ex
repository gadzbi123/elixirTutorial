defmodule AOC2_1 do
  def run() do
    File.stream!("./files/2.input")
    |> Stream.flat_map(&String.split(&1, ","))
    |> Stream.map(&String.to_integer(&1))
    |> Enum.to_list()
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
    |> operation()
    |> Enum.at(0)
  end

  def run_test(data) do
    data
    |> String.split(",")
    |> Enum.map(&String.to_integer(&1))
    # |> IO.inspect()
    |> operation()
  end

  def replace(input, x, y, z, func) do
    l = Enum.at(input, x)
    r = Enum.at(input, y)
    res = func.(l, r)
    input |> List.replace_at(z, res)
  end

  def operation(input, i \\ 0) do
    # IO.puts("input=#{inspect(input)},i=#{i}")

    op =
      input
      |> Enum.drop(i)
      |> Enum.take(4)

    # IO.puts("op=#{inspect(op)}")

    add = 1
    mul = 2
    stop = 99

    case op do
      [^add, x, y, z] ->
        input |> replace(x, y, z, &+/2) |> operation(i + 4)

      [^mul, x, y, z] ->
        input |> replace(x, y, z, &*/2) |> operation(i + 4)

      [^stop | _] ->
        input
    end
  end
end

AOC2_1.run() |> IO.inspect()
