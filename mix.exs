defmodule Behave.MixProject do
  use Mix.Project

  def project do
    [
      app: :behave,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      source_url: "https://github.com/anyalir/behave",
      description:
        "Behaviour driven development for ExUnit with product management friendly readable scenarios.",
      package: package(),
      docs: [
        main: "Behave",
        extras: ["README.md"]
      ]
    ]
  end

  def package do
    [
      name: :behave_bdd,
      licenses: ["MIT"],
      links: %{
        "Find me on GitHub" => "https://github.com/anyalir"
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test) do
    ["lib", "test/support"]
  end

  defp elixirc_paths(_) do
    ["lib"]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
