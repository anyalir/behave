defmodule Behave do
  @moduledoc """
  ~Ugh baby, `Behave`!
  Simple BDD style tests for elixir.
  """
  alias Behave.Scenario

  defmacro __using__(opts) do
    step_modules = Keyword.get(opts, :steps)

    if step_modules == nil do
      raise "Please specify your step implementation modules like so: use Behave, steps: [MyTestSteps, MyOtherTestSteps]."
    end

    imports =
      for module <- step_modules do
        quote do: import(unquote(module))
      end

    quote do
      import Behave
      alias Behave.Scenario
      unquote_splicing(imports)
    end
  end

  defmacro scenario(title, do: block) do
    quote do
      test unquote(title), args do
        var!(scenario) = Behave.Scenario.new(args)
        unquote(block)
        Behave.Scenario.run(var!(scenario))
      end
    end
  end

  defmacro given(name, args \\ []) do
    {module, name, arity} = find_target_fun(__CALLER__.requires, "given " <> name)
    fun = Function.capture(module, name, arity)

    quote do
      var!(scenario) = Behave.__given__(var!(scenario), unquote(fun), unquote(args))
    end
  end

  defmacro act(name, args \\ []) do
    {module, name, arity} = find_target_fun(__CALLER__.requires, "act " <> name)
    fun = Function.capture(module, name, arity)

    quote do
      var!(scenario) = Behave.__act__(var!(scenario), unquote(fun), unquote(args))
    end
  end

  defmacro check(name, args \\ []) do
    {module, name, arity} = find_target_fun(__CALLER__.requires, "check " <> name)
    fun = Function.capture(module, name, arity)

    quote do
      var!(scenario) = Behave.__check__(var!(scenario), unquote(fun), unquote(args))
    end
  end

  def __given__(scenario = %Scenario{}, step, args \\ []) do
    update_in(scenario.steps, &[{:given, step, args} | &1])
  end

  def __act__(scenario = %Scenario{}, step, args \\ []) do
    update_in(scenario.steps, &[{:act, step, args} | &1])
  end

  def __check__(scenario = %Scenario{}, step, args \\ []) do
    update_in(scenario.steps, &[{:check, step, args} | &1])
  end

  defp find_target_fun(modules, name) do
    atom_name = string_to_function_name(name)

    function_name_predicate = fn {name, _arity} -> name == atom_name end

    target_module =
      modules
      |> Enum.find(fn module ->
        module.__info__(:functions) |> Enum.any?(function_name_predicate)
      end)

    if target_module == nil do
      raise "Tried to find a step implementation for \"#{name}\", but none were defined. Did you forget an import?"
    end

    {target_function_name, target_function_arity} =
      target_module.__info__(:functions)
      |> Enum.find(function_name_predicate)

    {target_module, target_function_name, target_function_arity}
  end

  def string_to_function_name(string) do
    String.downcase(string)
    |> String.trim()
    |> String.replace(" ", "_")
    |> String.to_atom()
  end
end
