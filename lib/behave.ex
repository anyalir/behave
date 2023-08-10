defmodule Behave do
  @moduledoc """
  ~Ugh baby, `Behave`!
  Simple BDD style tests for elixir.
  """
  alias Behave.Scenario
  defmacro __using__(_opts) do
    quote do
      import Behave
      import Behave.Scenario
    end |> mdbg
  end

  defmacro scenario(title, do: block) do
    quote do
      test unquote(title) do
        var!(scenario) = Behave.Scenario.new()
        unquote(block)
        Behave.Scenario.run(var!(scenario))
      end
    end |> mdbg()
  end

  defmacro given(name, args \\ []) do
    {module, name, arity} = find_target_fun(__CALLER__.requires, "given " <> name)
    fun = Function.capture(module, name, arity)
    quote do
      var!(scenario) = Behave.__given__(var!(scenario), unquote(fun), unquote(args))
    end |> mdbg
  end

  defmacro act(name, args \\ []) do
    {module, name, arity} = find_target_fun(__CALLER__.requires, "act " <> name)
    fun = Function.capture(module, name, arity)
    quote do
      var!(scenario) = Behave.__act__(var!(scenario), unquote(fun), unquote(args))
    end |> mdbg
  end

  defmacro check(name, args \\ []) do
    {module, name, arity} = find_target_fun(__CALLER__.requires, "check " <> name)
    fun = Function.capture(module, name, arity)
    quote do
      var!(scenario) = Behave.__check__(var!(scenario), unquote(fun), unquote(args))
    end |> mdbg
  end
  defp mdbg(macro) do
    IO.puts(Macro.to_string(macro))
    macro
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
    atom_name = String.downcase(name) |> String.trim() |> String.replace(" ", "_") |> String.to_existing_atom()
    function_name_predicate = fn {name, _arity} -> name == atom_name end

    target_module = modules
    |> Enum.find(fn module ->
        module.__info__(:functions) |> Enum.any?(function_name_predicate)
    end)

    {target_function_name, target_function_arity} = target_module.__info__(:functions)
    |> Enum.find(function_name_predicate)

    {target_module, target_function_name, target_function_arity}
  end
end
