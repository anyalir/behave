defmodule BehaveError do
  @moduledoc false
  defexception [:message]
end

defmodule Behave do
  @moduledoc """
  ~Ugh baby, `Behave`!
  Simple BDD style tests for elixir.
  """

  defmacro __using__(opts \\ []) do
    file = Keyword.get(opts, :file)

    unless file do
      raise BehaveError,
        message: "Behave expect a `file` option."
    end

    unless String.ends_with?(file, ".feature") || File.exists?(file) do
      raise BehaveError,
        message: "Behave expect the passed path to be .feature file"
    end

    quote do
      import unquote(__MODULE__)

      Module.put_attribute(__MODULE__, :feature_file, unquote(file))
      Module.register_attribute(__MODULE__, :feature, accumulate: false)

      Module.put_attribute(__MODULE__, :before_compile, {unquote(__MODULE__), :load_features})
      Module.put_attribute(__MODULE__, :before_compile, {unquote(__MODULE__), :build_test_suite})
    end
  end

  defmacro load_features(%{module: module}) do
    quote bind_quoted: [module: module] do
      Module.get_attribute(module, :feature_file)
      |> File.stream!()
      |> Gherkin.parse()
      |> then(&Module.put_attribute(module, :feature, &1))
    end
  end

  defmacro build_test_suite(%{module: module}) do
    feature = Module.get_attribute(module, :feature)

    quote bind_quoted: [feature: Macro.escape(feature)] do
      Enum.each(feature.scenarios, fn scenario ->
        name =
          ExUnit.Case.register_test(__ENV__, :scenario, scenario.name, feature.tags)

        steps = feature.background_steps ++ scenario.steps

        def unquote(name)(context) do
          Enum.reduce(unquote(Macro.escape(steps)), context, fn step, acc ->
            apply(__MODULE__, String.to_atom(step.text), [acc])
            |> case do
              {:ok, result} ->
                Map.merge(acc, Map.new(result))

              _else ->
                acc
            end
          end)
        rescue
          e in UndefinedFunctionError ->
            raise BehaveError, "Undefined step: `#{e.function}`"
        end
      end)
    end
  end

  defmacro background(do: contents) do
    quote do
      unquote(contents)
    end
  end

  defmacro scenario(_title, do: contents) do
    quote do
      unquote(contents)
    end
  end

  defmacro given_(message, vars \\ Macro.escape(%{}), do: block) do
    quote do
      def unquote(String.to_atom(message))(unquote(vars)), do: unquote(block)
    end
  end

  defmacro when_(message, vars \\ Macro.escape(%{}), do: block) do
    quote do
      def unquote(String.to_atom(message))(unquote(vars)), do: unquote(block)
    end
  end

  defmacro then_(message, vars \\ Macro.escape(%{}), do: block) do
    quote do
      def unquote(String.to_atom(message))(unquote(vars)), do: unquote(block)
    end
  end

  defmacro and_(message, vars \\ Macro.escape(%{}), do: block) do
    quote do
      def unquote(String.to_atom(message))(unquote(vars)), do: unquote(block)
    end
  end

  defmacro but_(message, vars \\ Macro.escape(%{}), do: block) do
    quote do
      def unquote(String.to_atom(message))(unquote(vars)), do: unquote(block)
    end
  end
end
