# Golex

## The rules

1. Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
2. Any live cell with more than three live neighbours dies, as if by overcrowding.
3. Any live cell with two or three live neighbours lives on to the next generation.
4. Any dead cell with exactly three live neighbours becomes a live cell.

## Run!

You can run the application using the command `iex -S mix` and using the functions in the module `Utils` to instruments the world.

`Utils.create_world/1` create the cells (you can specify the number) and `Utils.tick/0` will tick the clock to the next generation. You can view the worls using `Utils.print` (be careful if the world is very big).
There are also a couple of function like `count` and `get_list` that are useful to inspect the live cells.

#### List all cells

```elixir
:ets.tab2list(:"keys_Elixir.Golex.CellRegistry")
```

#### Specify which node to use

```elixir
Horde.DynamicSupervisor.start_link(__MODULE__, [strategy: :one_for_one, distribution_strategy: Golex.LocalNodeDistribution], name: __MODULE__)
```
