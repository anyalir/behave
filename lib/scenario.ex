defmodule Behave.Scenario do
  defstruct steps: [], givens: [], results: []

  @spec new :: %Behave.Scenario{givens: [], results: [], steps: []}
  def new, do: %__MODULE__{}

  def run(scenario = %__MODULE__{steps: steps}) do
    steps
    |> Enum.reverse()
    |> Enum.reduce(scenario, fn step, scenario ->
      run_step(step, scenario)
    end)
  end

  def run_step({:given, fun, args}, scenario = %__MODULE__{}) do
    fun.(scenario, args)
  end

  def run_step({:act, fun, args}, scenario = %__MODULE__{}) do
    fun.(scenario, args)
  end

  def run_step({:check, fun, args}, scenario = %__MODULE__{}) do
    fun.(scenario, args)
  end
end
