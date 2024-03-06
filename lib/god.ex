defmodule Golex.God do

  def give_life() do

    cells = Horde.Registry.select(Golex.CellRegistry, [{{:"$1", :_, :_}, [], [:"$1"]}])

    Enum.reduce(cells, %{}, fn cell, acc ->
      get_neighbours(cell)
      |> Enum.reduce(acc, fn n, map ->
        Map.update(map, n, 1, fn v -> v + 1 end)
      end)
    end)
    |> Enum.filter(fn {_, v} -> v == 3 end)
    |> Enum.map(fn {c, _} ->
      Golex.HordeSupervisor.start_cell([c])
    end)
  end

  def get_neighbours({x, y}) do
    [ {x-1, y}, {x+1, y}, {x-1, y-1}, {x-1, y+1}, {x+1, y-1}, {x+1, y+1}, {x, y-1}, {x, y+1}]
  end

end
