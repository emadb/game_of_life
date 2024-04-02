defmodule Golex.HordeSupervisor do
  use Horde.DynamicSupervisor

  def start_link(_) do
    Horde.DynamicSupervisor.start_link(__MODULE__, [strategy: :one_for_one], name: __MODULE__)
<<<<<<< HEAD

    # Horde.DynamicSupervisor.start_link(__MODULE__, [strategy: :one_for_one, distribution_strategy: Golex.LocalNodeDistribution], name: __MODULE__)
=======
>>>>>>> a750623 (ready to start)
  end

  def init(init_arg) do
    [members: members()]
    |> Keyword.merge(init_arg)
    |> Horde.DynamicSupervisor.init()
  end

  def start_child(child_spec) do
    Horde.DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def members() do
    Enum.map([Node.self() | Node.list()], &{__MODULE__, &1})
  end
<<<<<<< HEAD

  def start_cell(coord) do
    start_child({Golex.Cell, coord})
  end
=======
>>>>>>> a750623 (ready to start)
end
