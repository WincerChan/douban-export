defmodule DoubanShow.MixProject do
  use Mix.Project

  def project do
    [
      app: :douban_show,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DoubanShow.Application, []},
      included_applications: [:mnesia]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:postgrex, "~> 0.15.3"},
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.6"},
      {:floki, "~> 0.24.0"},
      {:hackney, github: "benoitc/hackney", override: true}
    ]
  end
end
