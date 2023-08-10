defmodule Behave do
  @moduledoc """
  ~Ugh baby, `Behave`!
  Simple BDD style tests for elixir.
  """
  alias Behave.Scenario
  defmacro __using__(_) do
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

  defmacro given(fun, args \\ []) do
    quote do
      var!(scenario) = Behave.__given__(var!(scenario), unquote(fun), unquote(args))
    end |> mdbg
  end

  defmacro act(fun, args \\ []) do
    quote do
      var!(scenario) = Behave.__act__(var!(scenario), unquote(fun), unquote(args))
    end |> mdbg
  end

  defmacro check(fun, args \\ []) do
    quote do
      var!(scenario) = Behave.__check__(var!(scenario), unquote(fun), unquote(args))
    end |> mdbg
  end
  defp mdbg(macro) do
    IO.puts(Macro.to_string(macro))
    dbg()
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
end
