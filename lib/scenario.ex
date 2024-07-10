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
      def unquote(name)(scenario, _, _) do
        result = unquote(block)
        Behave.Scenario.__given__(scenario, result)
      end
    end
  end

  defmacro given(name, arguments, do: block) when is_list(arguments) do
    name = Behave.string_to_function_name("given_#{name}")

    quote do
      def unquote(name)(scenario, _, unquote(arguments)) do
        result = unquote(block)
        Behave.Scenario.__given__(scenario, result)
      end
    end
  end

  defmacro given(name, data, do: block) when not is_list(data) do
    name = Behave.string_to_function_name("given_#{name}")

    quote do
      def unquote(name)(scenario, unquote(data), _) do
        result = unquote(block)
        Behave.Scenario.__given__(scenario, result)
      end
    end
  end

  defmacro given(name, data, arguments, do: block)
           when not is_list(data) and is_list(arguments) do
    name = Behave.string_to_function_name("given_#{name}")

    quote do
      def unquote(name)(scenario, unquote(data), unquote(arguments)) do
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

  def __given__(scenario, _) do
    scenario
  end

  defmacro act(name, do: block) do
    name = Behave.string_to_function_name("act_#{name}")

    quote do
      def unquote(name)(scenario, _, _, _) do
        result = unquote(block)
        Behave.Scenario.__act__(scenario, result)
      end
    end
  end

  defmacro act(name, data, do: block) when not is_list(data) do
    name = Behave.string_to_function_name("act_#{name}")

    quote do
      def unquote(name)(scenario, unquote(data), _, _) do
        result = unquote(block)
        Behave.Scenario.__act__(scenario, result)
      end
    end
  end

  defmacro act(name, arguments, do: block) when is_list(arguments) do
    name = Behave.string_to_function_name("act_#{name}")

    quote do
      def unquote(name)(scenario, _, _, unquote(arguments)) do
        result = unquote(block)
        Behave.Scenario.__act__(scenario, result)
      end
    end
  end

  defmacro act(name, data, arguments, do: block) when is_list(arguments) and not is_list(data) do
    name = Behave.string_to_function_name("act_#{name}")

    quote do
      def unquote(name)(scenario, unquote(data), _, unquote(arguments)) do
        result = unquote(block)
        Behave.Scenario.__act__(scenario, result)
      end
    end
  end

  defmacro act(name, data, results, do: block) when not is_list(data) and not is_list(results) do
    name = Behave.string_to_function_name("act_#{name}")

    quote do
      def unquote(name)(scenario, unquote(data), unquote(results), _) do
        result = unquote(block)
        Behave.Scenario.__act__(scenario, result)
      end
    end
  end

  defmacro act(name, data, results, arguments, do: block)
           when not is_list(data) and not is_list(results) and is_list(arguments) do
    name = Behave.string_to_function_name("act_#{name}")

    quote do
      def unquote(name)(scenario, unquote(data), unquote(results), unquote(arguments)) do
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

  def __act__(scenario, _) do
    scenario
  end

  defmacro check(name, do: block) do
    name = Behave.string_to_function_name("check_#{name}")

    quote do
      def unquote(name)(scenario, _, _, _) do
        unquote(block)
        scenario
      end
    end
  end

  defmacro check(name, results, do: block) do
    name = Behave.string_to_function_name("check_#{name}")

    quote do
      def unquote(name)(scenario, unquote(results), _, _) do
        unquote(block)
        scenario
      end
    end
  end

  defmacro check(name, results, arguments, do: block)
           when is_list(arguments) and not is_list(results) do
    name = Behave.string_to_function_name("check_#{name}")

    quote do
      def unquote(name)(scenario, unquote(results), _, unquote(arguments)) do
        result = unquote(block)
        Behave.Scenario.__act__(scenario, result)
      end
    end
  end

  defmacro check(name, results, data, do: block)
           when not is_list(data) and not is_list(results) do
    name = Behave.string_to_function_name("check_#{name}")

    quote do
      def unquote(name)(scenario, unquote(results), unquote(data), _) do
        result = unquote(block)
        Behave.Scenario.__act__(scenario, result)
      end
    end
  end

  defmacro check(name, results, data, arguments, do: block)
           when not is_list(data) and not is_list(results) and is_list(arguments) do
    name = Behave.string_to_function_name("check_#{name}")

    quote do
      def unquote(name)(scenario, unquote(results), unquote(data), unquote(arguments)) do
        result = unquote(block)
        Behave.Scenario.__act__(scenario, result)
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
    fun.(scenario, scenario.data, args)
  end

  def run_step({:act, fun, args}, scenario = %__MODULE__{}) do
    fun.(scenario, scenario.data, scenario.results, args)
  end

  def run_step({:check, fun, args}, scenario = %__MODULE__{}) do
    fun.(scenario, scenario.results, scenario.data, args)
  end
end
