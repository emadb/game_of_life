defmodule Utils do
  @max_x 10000
  @max_y 10000

  def create_world(cells_count) do
    1..cells_count
    |> Enum.map(fn _ -> {Enum.random(1..@max_x), Enum.random(1..@max_y)} end)
    |> Enum.uniq()
    |> Enum.map(fn coord -> Golex.HordeSupervisor.start_cell([coord]) end)

  end

  def multi_tick(n) do
    Enum.each(1..n, fn _ ->
      tick()
      Process.sleep(100)
    end)
  end

  def print() do
    Printer.print_cells(get_list())
  end

  def tick() do
    cell_list = Horde.Registry.select(Golex.CellRegistry, [{{:"$1", :_, :_}, [], [:"$1"]}])
    Enum.map(cell_list, &Golex.Cell.define_next_gen/1)

    Golex.God.give_life()

    Enum.map(cell_list, &Golex.Cell.apply/1)
  end

  def count do
    Horde.Registry.count(Golex.CellRegistry)
  end

  def get_list do
    Horde.Registry.select(Golex.CellRegistry, [{{:"$1", :_, :_}, [], [:"$1"]}])
  end


  def create_block() do
    Golex.HordeSupervisor.start_cell([{1, 2}])
    Golex.HordeSupervisor.start_cell([{1, 1}])
    Golex.HordeSupervisor.start_cell([{2, 1}])
    Golex.HordeSupervisor.start_cell([{2, 2}])
    Printer.print_cells(get_list())
  end

  def create_glider() do
    Golex.HordeSupervisor.start_cell([{1, 2}])
    Golex.HordeSupervisor.start_cell([{2, 3}])
    Golex.HordeSupervisor.start_cell([{3, 1}])
    Golex.HordeSupervisor.start_cell([{3, 2}])
    Golex.HordeSupervisor.start_cell([{3, 3}])

    Printer.print_cells(get_list())
  end

end
