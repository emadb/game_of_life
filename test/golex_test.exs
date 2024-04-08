defmodule GolexTest do
  use ExUnit.Case

  describe "Any live cell with fewer than two live neighbours dies, as if caused by underpopulation." do
    test "is true" do
      assert true
    end
  end

  describe "Any live cell with more than three live neighbours dies, as if by overcrowding" do
  end

  describe "Any live cell with two or three live neighbours lives on to the next generation." do
  end

  describe "Any dead cell with exactly three live neighbours becomes a live cell." do
  end
end
