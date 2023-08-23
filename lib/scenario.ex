defmodule Behave.Scenario do
  defmacro __using__(_) do
    quote do
      import Behave.Scenario
    end
  end

  defstruct steps: [], data: %{}, results: %{}

  @type t :: %__MODULE__{}

  @spec new :: t
  def new, do: %__MODULE__{}

  defmacro given(name, do: block) do
    name = Behave.string_to_function_name("given_#{name}")

    quote do
      def unquote(name)(scenario, _) do
        result = unquote(block)
        Behave.Scenario.__given__(scenario, result)
      end
    end
  end

  defmacro given(name, args, do: block) do
    name = Behave.string_to_function_name("given_#{name}")

    quote do
      def unquote(name)(scenario, unquote(args)) do
        result = unquote(block)
        Behave.Scenario.__given__(scenario, result)
      end
    end
  end

  def __given__(scenario, {key, datum}) when is_function(datum) do
    update_in(scenario.data[key], datum)
  end

  def __given__(scenario, {key, datum}) do
    put_in(scenario.data[key], datum)
  end

  def __given__(scenario, :ignore) do
    scenario
  end

  def __given__(_scenario, _) do
    raise "Given needs to return a {:key, value} tuple or :ignore for executing side effects."
  end

  defmacro act(name, do: block) do
    name = Behave.string_to_function_name("act_#{name}")

    quote do
      def unquote(name)(scenario, _) do
        var!(data) = scenario.data
        result = unquote(block)
        Behave.Scenario.__act__(scenario, result)
      end
    end
  end

  defmacro act(name, args, do: block) do
    name = Behave.string_to_function_name("act_#{name}")

    quote do
      def unquote(name)(scenario, unquote(args)) do
        var!(data) = scenario.data
        result = unquote(block)
        Behave.Scenario.__act__(scenario, result)
      end
    end
  end

  def __act__(scenario, {key, datum}) when is_function(datum) do
    result = datum.(scenario.data[key])
    put_in(scenario.results[key], result)
  end

  def __act__(scenario, {key, datum}) do
    put_in(scenario.results[key], datum)
  end

  def __act__(scenario, :ignore) do
    scenario
  end

  def __act__(_scenario, _) do
    raise "Act needs to return a {:key, value} tuple or :ignore for executing side effects."
  end

  defmacro check(name, do: block) do
    name = Behave.string_to_function_name("check_#{name}")

    quote do
      def unquote(name)(scenario, _) do
        var!(results) = scenario.results
        unquote(block)
        scenario
      end
    end
  end

  defmacro check(name, args, do: block) do
    name = Behave.string_to_function_name("check_#{name}")

    quote do
      def unquote(name)(scenario, unquote(args)) do
        var!(data) = scenario.data
        var!(results) = scenario.results
        unquote(block)
        scenario
      end
    end
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
