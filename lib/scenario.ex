defmodule Behave.Scenario do
  defmacro __using__(_) do
    quote do
      import Behave.Scenario
    end
  end

  defstruct steps: [], data: [], results: []

  @spec new :: %Behave.Scenario{data: [], results: [], steps: []}
  def new, do: %__MODULE__{}

  defmacro given(name, args) do
    name = Behave.string_to_function_name("given_#{name}")
    block = Keyword.get(args, :do)

    args_without_do =
      args
      |> Enum.filter(fn {key, _} ->
        key != :do
      end)

    quote do
      def unquote(name)(scenario, unquote(args_without_do)) do
        result = unquote(block)
        Behave.Scenario.__given__(scenario, result)
      end
    end
    |> Behave.mdbg()
  end

  def __given__(scenario, {key, datum}) when is_function(datum) do
    update_in(scenario.data[key], datum)
  end

  def __given__(scenario, {key, datum}) do
    put_in(scenario.data[key], datum)
  end

  def __given__(_scenario, :ignore) do
    :ok
  end

  def __given__(_scenario, _) do
    raise "Given needs to return a {:key, value} tuple or :ignore for executing side effects."
  end

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
