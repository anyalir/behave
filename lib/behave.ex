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

  @spec scenario(any, [{:do, any}, ...]) ::
          nonempty_binary
          | {:import, [{atom, any}, ...], [{any, any, any}, ...]}
          | {:test, [{atom, any}, ...], [...]}
  defmacro scenario(title, do: block) do
    quote do
      test unquote(title) do
        Behave.Scenario.new()
        |> unquote(block)
      end
    end |> mdbg()
  end

  defmacro given(description) do
    quote do
      unquote("|> given_" <> Macro.underscore(description))
    end |> mdbg
  end

  defp mdbg(macro) do
    IO.puts(Macro.to_string(macro))
    macro
  end

  def __given__(scenario = %Scenario{}, step) do
    update_in(scenario.steps, &[{:given, step} | &1])
  end

  def __when__(scenario = %Scenario{}, step) do
    update_in(scenario.steps, &[{:when, step} | &1])
  end

  def __then__(scenario = %Scenario{}, step) do
    update_in(scenario.steps, &[{:then, step} | &1])
  end
end
