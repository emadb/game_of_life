defmodule GolexTest do
  use ExUnit.Case

  describe "Any live cell with fewer than two live neighbours dies, as if caused by underpopulation." do
    test "Zero neighbours" do
      {:ok, pid} = start_supervised({Golex.Cell, [{1, 1}]})
      Golex.Cell.tick({1, 1})

      assert Process.alive?(pid) == false
    end

    test "One neighbour" do
      {:ok, pid} = start_supervised({Golex.Cell, [{1, 1}]})
      start_supervised({Golex.Cell, [{1, 2}]})
      Golex.Cell.tick({1, 1})

      assert Process.alive?(pid) == false
    end

    test "One neighbour and one not neighbour" do
      {:ok, pid} = start_supervised({Golex.Cell, [{1, 1}]})
      start_supervised({Golex.Cell, [{1, 2}]})
      start_supervised({Golex.Cell, [{6, 7}]})
      Golex.Cell.tick({1, 1})

      assert Process.alive?(pid) == false
    end
  end

  describe "Any live cell with more than three live neighbours dies, as if by overcrowding" do
    test "4 neighbours" do
      {:ok, pid} = start_supervised({Golex.Cell, [{2, 2}]})
      start_supervised({Golex.Cell, [{1, 2}]})
      start_supervised({Golex.Cell, [{3, 2}]})
      start_supervised({Golex.Cell, [{2, 1}]})
      start_supervised({Golex.Cell, [{2, 3}]})
      Golex.Cell.tick({2, 2})

      assert Process.alive?(pid) == false
    end

    test "5 neighbours" do
      {:ok, pid} = start_supervised({Golex.Cell, [{2, 2}]})
      start_supervised({Golex.Cell, [{1, 2}]})
      start_supervised({Golex.Cell, [{3, 2}]})
      start_supervised({Golex.Cell, [{2, 1}]})
      start_supervised({Golex.Cell, [{2, 3}]})
      start_supervised({Golex.Cell, [{3, 3}]})
      Golex.Cell.tick({2, 2})

      assert Process.alive?(pid) == false
    end
  end

  describe "Any live cell with two or three live neighbours lives on to the next generation." do
    test "2 neighbours" do
      # {:ok, pid} = start_supervised({Golex.Cell, [{2, 2}]})
      # start_supervised({Golex.Cell, [{1, 2}]})
      # start_supervised({Golex.Cell, [{3, 2}]})

      {:ok,pid} = Golex.Cell.start_link([{2, 2}])
      Golex.Cell.start_link([{1, 2}])
      Golex.Cell.start_link([{3, 2}])

      Golex.Cell.tick({2, 2})
      assert Process.alive?(pid) == true
    end

    test "3 neighbours" do
      # {:ok, pid} = start_supervised({Golex.Cell, [{2, 2}]})
      # start_supervised({Golex.Cell, [{1, 2}]})
      # start_supervised({Golex.Cell, [{3, 2}]})

      {:ok,pid} = Golex.Cell.start_link([{4, 4}])
      Golex.Cell.start_link([{3, 4}])
      Golex.Cell.start_link([{5, 4}])
      Golex.Cell.start_link([{5, 5}])

      Golex.Cell.tick({4, 4})
      assert Process.alive?(pid) == true
    end
  end

  describe "Any dead cell with exactly three live neighbours becomes a live cell." do
    test "3 neighbours" do
      Golex.Cell.start_link([{3, 4}])
      Golex.Cell.start_link([{5, 4}])
      Golex.Cell.start_link([{5, 5}])

      Golex.God.give_life()

      assert [{_, nil}] = Horde.Registry.lookup(Golex.CellRegistry, {4, 4})
    end
  end

  describe "God" do
    test "fake" do
      res = Golex.God.fake([{2, 3}, {3, 2}, {3, 3}, {1, 2}, {3, 1}])
      IO.inspect res
    end

  end
end
