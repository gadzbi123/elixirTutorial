defmodule AOC2Test do
  use ExUnit.Case
  doctest AOC2_1

  test "Simple input" do
    data = "1,9,10,3,2,3,11,0,99,30,40,50"
    assert AOC2_1.run_test(data) == [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]
  end

  test "simple 1" do
    data = "1,0,0,0,99"
    assert AOC2_1.run_test(data) == [2, 0, 0, 0, 99]
  end

  test "simple 2" do
    data = "2,3,0,3,99"
    assert AOC2_1.run_test(data) == [2, 3, 0, 6, 99]
  end

  test "simple 3" do
    data = "2,4,4,5,99,0"
    assert AOC2_1.run_test(data) == [2, 4, 4, 5, 99, 9801]
  end

  test "simple 4" do
    data = "1,1,1,4,99,5,6,0,99"
    assert AOC2_1.run_test(data) == [30, 1, 1, 4, 2, 5, 6, 0, 99]
  end

  test "2_2 run" do
    assert AOC2_2.run(64, 17) == 19_690_720
  end
end
