defmodule TestSteps do
  use Behave.Scenario
  import ExUnit.Assertions

  given "coffee machine" do
    {:coffee_machine, CoffeeMachine.new()}
  end

  given "it has water", %{args: [amount: amount]} do
    {:coffee_machine, &CoffeeMachine.add_water(&1, amount)}
  end

  given "it has coffee", %{args: [cultivar: cultivar]} do
    {:coffee_machine, &CoffeeMachine.add_coffee(&1, cultivar)}
  end

  act "i press the button", %{data: data} do
    {:coffee, CoffeeMachine.brew(data.coffee_machine)}
  end

  check "it makes coffee", %{results: results} do
    assert results.coffee != :disappointment
  end
end
