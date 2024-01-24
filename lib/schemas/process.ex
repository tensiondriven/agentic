defmodule Agentic.Process do
  @moduledoc """
  Agents are fashioned after CrewAI's agents:

  role='Senior Research Analyst',
  goal='Uncover cutting-edge developments in AI and data science',
  backstory=You work at a leading tech think tank.
  Your expertise lies in identifying emerging trends.
  You have a knack for dissecting complex data and presenting
  actionable insights.
  verbose=True,
  allow_delegation=False,
  tools=[search_tool]

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
