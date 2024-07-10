defmodule TestSteps do
  use Behave.Scenario
  import ExUnit.Assertions

  given "coffee machine" do
    {:coffee_machine, CoffeeMachine.new()}
  end

  given "it has water", amount: amount do
    {:coffee_machine, &CoffeeMachine.add_water(&1, amount)}
  end

  given "it has coffee", cultivar: cultivar do
    {:coffee_machine, &CoffeeMachine.add_coffee(&1, cultivar)}
  end

  given "it has water and coffee", %{coffee_machine: it}, amount: amount, cultivar: cultivar do
    { :coffee_machine, 
      it
      |> CoffeeMachine.add_water(amount)
      |> CoffeeMachine.add_coffee(cultivar)
    }
  end

  act "i press the button", %{coffee_machine: coffee_machine} do
    {:coffee, CoffeeMachine.brew(coffee_machine)}
  end

  check "it makes coffee", results do
    assert results.coffee != :disappointment
  end
end
