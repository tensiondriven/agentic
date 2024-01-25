defmodule Agentic.Process do
  @moduledoc """
  A process encapsulates a set of agents working on tasks.

  """
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :description, :string
    embeds_many :agents, Agentic.Agent
  end

  defp load(filename) do
  end

  defp execute() do
  end
end
