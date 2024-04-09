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
      {:ok, _} = start_supervised({Golex.Cell, [{1, 1}]}, id: :c1)
      {:ok, _} = start_supervised({Golex.Cell, [{1, 2}]}, id: :c2)
      %{next_state: next_state} = Golex.Cell.define_next_gen({1, 1})

      assert next_state == :dead
    end

    test "One neighbour (apply)" do
      {:ok, pid} = start_supervised({Golex.Cell, [{1, 1}]}, id: :c1)
      {:ok, _} = start_supervised({Golex.Cell, [{1, 2}]}, id: :c2)
      Golex.Cell.define_next_gen({1, 1})
      Golex.Cell.apply({1, 1})

      assert Process.alive?(pid) == false
    end

    test "One neighbour and one not neighbour (next)" do
      {:ok, _} = start_supervised({Golex.Cell, [{1, 1}]}, id: :c1)
      start_supervised({Golex.Cell, [{1, 2}]}, id: :c2)
      start_supervised({Golex.Cell, [{6, 7}]}, id: :c3)
      %{next_state: next_state} = Golex.Cell.define_next_gen({1, 1})

      assert next_state == :dead
    end

    test "One neighbour and one not neighbour (apply)" do
      {:ok, pid} = start_supervised({Golex.Cell, [{1, 1}]}, id: :c1)
      start_supervised({Golex.Cell, [{1, 2}]}, id: :c2)
      start_supervised({Golex.Cell, [{6, 7}]}, id: :c3)
      Golex.Cell.define_next_gen({1, 1})
      Golex.Cell.apply({1, 1})

      assert Process.alive?(pid) == false
    end
  end

  describe "Any live cell with more than three live neighbours dies, as if by overcrowding" do
    test "4 neighbours (next)" do
      {:ok, _} = start_supervised({Golex.Cell, [{2, 2}]}, id: :c1)
      {:ok, _} = start_supervised({Golex.Cell, [{1, 2}]}, id: :c2)
      {:ok, _} = start_supervised({Golex.Cell, [{3, 2}]}, id: :c3)
      {:ok, _} = start_supervised({Golex.Cell, [{2, 1}]}, id: :c4)
      {:ok, _} = start_supervised({Golex.Cell, [{2, 3}]}, id: :c5)
      %{next_state: next_state} = Golex.Cell.define_next_gen({2, 2})

      assert next_state == :dead
    end

    test "4 neighbours (apply)" do
      {:ok, pid} = start_supervised({Golex.Cell, [{2, 2}]}, id: :c1)
      {:ok, _} = start_supervised({Golex.Cell, [{1, 2}]}, id: :c2)
      {:ok, _} = start_supervised({Golex.Cell, [{3, 2}]}, id: :c3)
      {:ok, _} = start_supervised({Golex.Cell, [{2, 1}]}, id: :c4)
      {:ok, _} = start_supervised({Golex.Cell, [{2, 3}]}, id: :c5)
      Golex.Cell.define_next_gen({2, 2})
      Golex.Cell.apply({2, 2})

      assert Process.alive?(pid) == false
    end

    test "5 neighbours (next)" do
      {:ok, _} = start_supervised({Golex.Cell, [{2, 2}]}, id: :c1)
      {:ok, _} = start_supervised({Golex.Cell, [{1, 2}]}, id: :c2)
      {:ok, _} = start_supervised({Golex.Cell, [{3, 2}]}, id: :c3)
      {:ok, _} = start_supervised({Golex.Cell, [{2, 1}]}, id: :c4)
      {:ok, _} = start_supervised({Golex.Cell, [{2, 3}]}, id: :c5)
      {:ok, _} = start_supervised({Golex.Cell, [{3, 3}]}, id: :c6)
      %{next_state: next_state} = Golex.Cell.define_next_gen({2, 2})

      assert next_state == :dead
    end

    test "5 neighbours (apply)" do
      {:ok, pid} = start_supervised({Golex.Cell, [{2, 2}]}, id: :c1)
      {:ok, _} = start_supervised({Golex.Cell, [{1, 2}]}, id: :c2)
      {:ok, _} = start_supervised({Golex.Cell, [{3, 2}]}, id: :c3)
      {:ok, _} = start_supervised({Golex.Cell, [{2, 1}]}, id: :c4)
      {:ok, _} = start_supervised({Golex.Cell, [{2, 3}]}, id: :c5)
      {:ok, _} = start_supervised({Golex.Cell, [{3, 3}]}, id: :c6)
      Golex.Cell.define_next_gen({2, 2})
      Golex.Cell.apply({2, 2})

      assert Process.alive?(pid) == false
    end
  end

  describe "Any live cell with two or three live neighbours lives on to the next generation." do
    test "2 neighbours (next)" do
      {:ok, _} = start_supervised({Golex.Cell, [{2, 2}]}, id: :c1)
      start_supervised({Golex.Cell, [{1, 2}]}, id: :c2)
      start_supervised({Golex.Cell, [{3, 2}]}, id: :c3)

      %{next_state: next_state} = Golex.Cell.define_next_gen({2, 2})

      assert next_state == :alive
    end

    test "2 neighbours (apply)" do
      {:ok, pid} = start_supervised({Golex.Cell, [{2, 2}]}, id: :c1)
      start_supervised({Golex.Cell, [{1, 2}]}, id: :c2)
      start_supervised({Golex.Cell, [{3, 2}]}, id: :c3)

      Golex.Cell.define_next_gen({2, 2})
      Golex.Cell.apply({2, 2})

      assert Process.alive?(pid) == true
    end

    test "3 neighbours (next)" do
      {:ok, _} = start_supervised({Golex.Cell, [{4, 4}]}, id: :c1)
      {:ok, _} = start_supervised({Golex.Cell, [{3, 4}]}, id: :c2)
      {:ok, _} = start_supervised({Golex.Cell, [{5, 4}]}, id: :c3)
      {:ok, _} = start_supervised({Golex.Cell, [{5, 5}]}, id: :c4)

      %{next_state: next_state} = Golex.Cell.define_next_gen({4, 4})

      assert next_state == :alive
    end

    test "3 neighbours (apply)" do
      {:ok, pid} = start_supervised({Golex.Cell, [{4, 4}]}, id: :c1)
      {:ok, _} = start_supervised({Golex.Cell, [{3, 4}]}, id: :c2)
      {:ok, _} = start_supervised({Golex.Cell, [{5, 4}]}, id: :c3)
      {:ok, _} = start_supervised({Golex.Cell, [{5, 5}]}, id: :c4)

      Golex.Cell.define_next_gen({4, 4})
      Golex.Cell.apply({4, 4})

      assert Process.alive?(pid) == true
    end
  end

  describe "Any dead cell with exactly three live neighbours becomes a live cell." do
    test "3 neighbours" do
      {:ok, _} = start_supervised({Golex.Cell, [{10, 10}]}, id: :c1)
      {:ok, _} = start_supervised({Golex.Cell, [{10, 11}]}, id: :c2)
      {:ok, _} = start_supervised({Golex.Cell, [{11, 10}]}, id: :c3)

      Golex.God.give_life()

      assert [{_, nil}] = Horde.Registry.lookup(Golex.CellRegistry, {11, 11})
    end
  end
end
