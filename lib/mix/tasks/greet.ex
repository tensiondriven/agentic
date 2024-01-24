defmodule Mix.Tasks.Greet do
  use Mix.Task
  @shortdoc "Outputs a greeting"
  def run(_args) do
    IO.puts "We are better together"
  end
end
