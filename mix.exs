defmodule Imglab.MixProject do
  use Mix.Project

  def project do
    [
      app: :imglab,
      version: "0.3.0",
      elixir: "~> 1.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "imglab",
      source_url: "https://github.com/imglab-io/imglab-ex",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:dialyxir, "~> 1.1", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Official imglab Elixir library."
  end

  defp package do
    [
      name: "imglab",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["imglab"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/imglab-io/imglab-ex"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "LICENSE"]
    ]
  end
end
