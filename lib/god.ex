defmodule Golex.God do
  def give_life() do
    live_cells = Horde.Registry.select(Golex.CellRegistry, [{{:"$1", :_, :_}, [], [:"$1"]}])

    live_cells
    |> find_potential_newborns()
    |> count_neighbours()
    |> select_new_live_cells(live_cells)
    |> born_life()
  end

  defp find_potential_newborns(live_cells) do
    Enum.flat_map(live_cells, &get_neighbours/1)
  end

  defp count_neighbours(neighbours) do
    Enum.reduce(neighbours, %{}, fn neighbour, acc ->
      Map.update(acc, neighbour, 1, &(&1 + 1))
    end)
  end

  defp select_new_live_cells(neighbour_counts, live_cells) do
    neighbour_counts
    |> Enum.filter(fn {_, count} -> count == 3 end)
    |> Enum.reject(fn {coord, _} -> Enum.member?(live_cells, coord) end)
    |> Enum.map(fn {coord, _} -> coord end)
  end

  defp born_life(cells) do
    Enum.each(cells, &born_cell/1)
  end

  defp born_cell(cell) do
    {:ok, _} = Golex.HordeSupervisor.start_cell([cell])
  end

  def get_neighbours({x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x - 1, y - 1},
      {x - 1, y + 1},
      {x + 1, y - 1},
      {x + 1, y + 1},
      {x, y - 1},
      {x, y + 1}
    ]
  end
end
