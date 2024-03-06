defmodule GolexTest do
  use ExUnit.Case

  describe "Any live cell with fewer than two live neighbours dies, as if caused by underpopulation." do
    test "Zero neighbours (next)" do
      {:ok, _} = start_supervised({Golex.Cell, [{1, 1}]})
      %{next_state: next_state} = Golex.Cell.define_next_gen({1, 1})

      assert next_state == :dead
    end

    test "Zero neighbours (apply)" do
      {:ok, pid} = start_supervised({Golex.Cell, [{1, 1}]})
      Golex.Cell.define_next_gen({1, 1})
      Golex.Cell.apply({1, 1})

      assert Process.alive?(pid) == false
    end

    test "One neighbour (next)" do
      {:ok, _} = start_supervised({Golex.Cell, [{1, 1}]})
      start_supervised({Golex.Cell, [{1, 2}]})
      %{next_state: next_state} = Golex.Cell.define_next_gen({1, 1})

      assert next_state == :dead
    end

    test "One neighbour (apply)" do
      {:ok, pid} = start_supervised({Golex.Cell, [{1, 1}]})
      start_supervised({Golex.Cell, [{1, 2}]})
      Golex.Cell.define_next_gen({1, 1})
      Golex.Cell.apply({1, 1})

      assert Process.alive?(pid) == false
    end

    test "One neighbour and one not neighbour (next)" do
      {:ok, _} = start_supervised({Golex.Cell, [{1, 1}]})
      start_supervised({Golex.Cell, [{1, 2}]})
      start_supervised({Golex.Cell, [{6, 7}]})
      %{next_state: next_state} = Golex.Cell.define_next_gen({1, 1})

      assert next_state == :dead
    end

    test "One neighbour and one not neighbour (apply)" do
      {:ok, pid} = start_supervised({Golex.Cell, [{1, 1}]})
      start_supervised({Golex.Cell, [{1, 2}]})
      start_supervised({Golex.Cell, [{6, 7}]})
      Golex.Cell.define_next_gen({1, 1})
      Golex.Cell.apply({1, 1})

      assert Process.alive?(pid) == false
    end
  end

  describe "Any live cell with more than three live neighbours dies, as if by overcrowding" do
    test "4 neighbours (next)" do
      {:ok, _} = start_supervised({Golex.Cell, [{2, 2}]})
      start_supervised({Golex.Cell, [{1, 2}]})
      start_supervised({Golex.Cell, [{3, 2}]})
      start_supervised({Golex.Cell, [{2, 1}]})
      start_supervised({Golex.Cell, [{2, 3}]})
      %{next_state: next_state} = Golex.Cell.define_next_gen({2, 2})

      assert next_state == :dead
    end

    test "4 neighbours (apply)" do
      {:ok, pid} = start_supervised({Golex.Cell, [{2, 2}]})
      start_supervised({Golex.Cell, [{1, 2}]})
      start_supervised({Golex.Cell, [{3, 2}]})
      start_supervised({Golex.Cell, [{2, 1}]})
      start_supervised({Golex.Cell, [{2, 3}]})
      Golex.Cell.define_next_gen({2, 2})
      Golex.Cell.apply({2, 2})

      assert Process.alive?(pid) == false
    end

    test "5 neighbours (next)" do
      {:ok, _} = start_supervised({Golex.Cell, [{2, 2}]})
      start_supervised({Golex.Cell, [{1, 2}]})
      start_supervised({Golex.Cell, [{3, 2}]})
      start_supervised({Golex.Cell, [{2, 1}]})
      start_supervised({Golex.Cell, [{2, 3}]})
      start_supervised({Golex.Cell, [{3, 3}]})
      %{next_state: next_state} = Golex.Cell.define_next_gen({2, 2})

      assert next_state == :dead
    end
    test "5 neighbours (apply)" do
      {:ok, pid} = start_supervised({Golex.Cell, [{2, 2}]})
      start_supervised({Golex.Cell, [{1, 2}]})
      start_supervised({Golex.Cell, [{3, 2}]})
      start_supervised({Golex.Cell, [{2, 1}]})
      start_supervised({Golex.Cell, [{2, 3}]})
      start_supervised({Golex.Cell, [{3, 3}]})
      Golex.Cell.define_next_gen({2, 2})
      Golex.Cell.apply({2, 2})

      assert Process.alive?(pid) == false
    end
  end

  describe "Any live cell with two or three live neighbours lives on to the next generation." do
    test "2 neighbours (next)" do
      # {:ok, pid} = start_supervised({Golex.Cell, [{2, 2}]})
      # start_supervised({Golex.Cell, [{1, 2}]})
      # start_supervised({Golex.Cell, [{3, 2}]})

      {:ok, _} = Golex.Cell.start_link([{2, 2}])
      Golex.Cell.start_link([{1, 2}])
      Golex.Cell.start_link([{3, 2}])

      %{next_state: next_state} = Golex.Cell.define_next_gen({2, 2})


      assert next_state == :live
    end

    test "2 neighbours (apply)" do
      # {:ok, pid} = start_supervised({Golex.Cell, [{2, 2}]})
      # start_supervised({Golex.Cell, [{1, 2}]})
      # start_supervised({Golex.Cell, [{3, 2}]})

      {:ok,pid} = Golex.Cell.start_link([{2, 2}])
      Golex.Cell.start_link([{1, 2}])
      Golex.Cell.start_link([{3, 2}])

      Golex.Cell.define_next_gen({2, 2})
      Golex.Cell.apply({2, 2})

      assert Process.alive?(pid) == true
    end

    test "3 neighbours (next)" do
      # {:ok, pid} = start_supervised({Golex.Cell, [{2, 2}]})
      # start_supervised({Golex.Cell, [{1, 2}]})
      # start_supervised({Golex.Cell, [{3, 2}]})

      {:ok, _} = Golex.Cell.start_link([{4, 4}])
      Golex.Cell.start_link([{3, 4}])
      Golex.Cell.start_link([{5, 4}])
      Golex.Cell.start_link([{5, 5}])

      %{next_state: next_state} = Golex.Cell.define_next_gen({4, 4})

      assert next_state == :live
    end


    test "3 neighbours (apply)" do
      # {:ok, pid} = start_supervised({Golex.Cell, [{2, 2}]})
      # start_supervised({Golex.Cell, [{1, 2}]})
      # start_supervised({Golex.Cell, [{3, 2}]})

      {:ok,pid} = Golex.Cell.start_link([{4, 4}])
      Golex.Cell.start_link([{3, 4}])
      Golex.Cell.start_link([{5, 4}])
      Golex.Cell.start_link([{5, 5}])

      Golex.Cell.define_next_gen({4, 4})
      Golex.Cell.apply({4, 4})

      assert Process.alive?(pid) == true
    end
  end

  describe "Any dead cell with exactly three live neighbours becomes a live cell." do
    test "3 neighbours" do
      Golex.Cell.start_link([{10, 10}])
      Golex.Cell.start_link([{10, 11}])
      Golex.Cell.start_link([{11, 10}])

      Golex.God.give_life()

      assert [{_, nil}] = Horde.Registry.lookup(Golex.CellRegistry, {11, 11})
    end
  end

end
