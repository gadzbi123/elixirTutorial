defmodule AOC2_2 do
  def run(arg1, arg2) do
    File.stream!("./files/2.input")
    |> Stream.flat_map(&String.split(&1, ","))
    |> Stream.map(&String.to_integer(&1))
    |> Enum.to_list()
    |> List.replace_at(1, arg1)
    |> List.replace_at(2, arg2)
    |> operation()
    |> Enum.at(0)
  end

  def find_args() do
    for x <- 0..99, y <- 0..99 do
      if run(x, y) == 19_690_720 do
        IO.puts(100 * x + y)
      end
    end
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
