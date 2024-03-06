defmodule Golex.God do

  def give_life() do

    live_cells = Horde.Registry.select(Golex.CellRegistry, [{{:"$1", :_, :_}, [], [:"$1"]}])

    Enum.reduce(live_cells, %{}, fn cell, acc ->
      map_potential_neighbours(cell, acc)
    end)
    |> Enum.filter(fn {_, v} -> v == 3 end)
    |> Enum.reject(fn {coord, 3} -> Enum.member?(live_cells, coord) end)
    |> Enum.map(fn {c, _} ->
      {:ok, _} = Golex.HordeSupervisor.start_cell([c])
    end)
  end

  def map_potential_neighbours(cell, acc) do
    Enum.reduce(get_neighbours(cell), acc, fn n, map ->
      Map.update(map, n, 1, fn v -> v + 1 end)
    end)
  end

  def get_neighbours({x, y}) do
    [ {x-1, y}, {x+1, y}, {x-1, y-1}, {x-1, y+1}, {x+1, y-1}, {x+1, y+1}, {x, y-1}, {x, y+1}]
  end


  def fake(live_cells) do
    Enum.reduce(live_cells, %{}, fn cell, acc ->
      map_potential_neighbours(cell, acc)
    end)
    |> Enum.filter(fn {_, v} -> v == 3 end)
    |> Enum.reject(fn {coord, 3} -> Enum.member?(live_cells, coord) end)
  end

end
