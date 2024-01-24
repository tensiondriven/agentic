defmodule Agentic.MixProject do
  use Mix.Project

  def project do
    [
      app: :agentic,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.11.1"},
      {:openai_ex, "~> 0.5.6"},
      {:yaml_elixir, "~> 2.9.0"},
      {:ex_json_schema, "~> 0.10.2"}
    ]
  end
end
