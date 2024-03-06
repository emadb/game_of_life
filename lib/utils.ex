defmodule Utils do
  @max_x 100
  @max_y 100

  def create_world(cells_count) do
    1..cells_count
    |> Enum.map(fn _ -> {Enum.random(1..@max_x), Enum.random(1..@max_y)} end)
    |> Enum.map(fn coord -> Golex.HordeSupervisor.start_cell([coord]) end)
  end

  def tick do
    Horde.Registry.select(Golex.CellRegistry, [{{:"$1", :_, :_}, [], [:"$1"]}])
    |> Enum.map(fn cell -> Golex.Cell.tick(cell) end)
  end

  def count do
    Horde.Registry.count(Golex.CellRegistry)
  end

  def get_list do
    Horde.Registry.select(Golex.CellRegistry, [{{:"$1", :_, :_}, [], [:"$1"]}])
  end


end
