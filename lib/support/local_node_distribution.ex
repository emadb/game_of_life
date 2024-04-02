defmodule Golex.LocalNodeDistribution do
  @behaviour Horde.DistributionStrategy

  def choose_node(_identifier, _members) do
    {:ok,
     %Horde.DynamicSupervisor.Member{
       status: :alive,
       name: {Golex.HordeSupervisor, Node.self()}
     }}
  end

  def has_quorum?(_members), do: true
end
