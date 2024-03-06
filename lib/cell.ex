defmodule Golex.Cell do
  use GenServer, restart: :transient

  def start_link([coord]) do
    GenServer.start_link(__MODULE__, [coord], name: via_tuple(coord))
  end

  def init([coord]) do
    {:ok, %{coord: coord, gen: 0, next_state: :none}}
  end

  def define_next_gen(coord) do
    GenServer.call(via_tuple(coord), :define_next_gen)
    coord
  end

  def apply(coord) do
    GenServer.call(via_tuple(coord), :apply)
    coord
  end

  def handle_call(:define_next_gen, _from, %{coord: coord, gen: gen, next_state: :none}) do
    if count_neighbours(coord) == 2 || count_neighbours(coord) == 3 do
      {:reply, coord, %{coord: coord, gen: gen, next_state: :live}}
    else
      {:reply, coord, %{coord: coord, gen: gen, next_state: :dead}}
    end
  end

  def handle_call(:apply, _from, %{coord: coord, gen: gen, next_state: :dead}) do
    {:stop, :shutdown, coord, %{coord: coord, gen: gen}}
  end

  def handle_call(:apply, _from, %{coord: coord, gen: gen, next_state: :live}) do
    {:reply, coord, %{coord: coord, gen: gen + 1, next_state: :none}}
  end

  def count_neighbours({x, y}) do
    [ {x-1, y}, {x+1, y}, {x-1, y-1}, {x-1, y+1}, {x+1, y-1}, {x+1, y+1}, {x, y-1}, {x, y+1}]
    |> Enum.reduce(0, fn coord, acc ->
      case Horde.Registry.lookup(Golex.CellRegistry, coord) do
        [{_pid, _}] -> acc + 1
        [] -> acc
      end
    end)
  end

  defp via_tuple(coord) do
    {:via, Horde.Registry, {Golex.CellRegistry, coord}}
  end
end
