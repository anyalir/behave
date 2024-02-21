defmodule TestSteps do
  use ExUnit.Case
  use Behave.Scenario
  import ExUnit.Assertions

  given "coffee machine", [], %Behave.Scenario{data: %{name: name}} do
    {:coffee_machine, CoffeeMachine.new(name)}
  end

  given "it has water", amount: amount do
    {:coffee_machine, &CoffeeMachine.add_water(&1, amount)}
  end

  given "it has coffee", cultivar: cultivar do
    {:coffee_machine, &CoffeeMachine.add_coffee(&1, cultivar)}
  end

  act "i press the button", [], %Behave.Scenario{data: data} do
    {:coffee, CoffeeMachine.brew(data.coffee_machine)}
  end

  check "it makes coffee", [], %Behave.Scenario{results: results} do
    assert results.coffee != :disappointment
  end
end
