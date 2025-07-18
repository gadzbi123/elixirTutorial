defmodule AOC5 do
  def solve1() do
    File.stream!("./files/2025_5.input")
    |> Enum.map(&String.split(&1, ["|", ","]))
    |> Enum.reduce(%{}, &conquer/2)
  end

  def conquer([left, right], acc) do
    Map.put(acc, left, right)
  end

  def conquer(list, acc) when length(list) > 2 do
    find_valid_middles()
  end
  
  def find_valid_middle(list,rules) do
    Enum.reduce(list,-1,fn x,acc-> 
        Map.get(rules,x)
    end)
    
  end
end
