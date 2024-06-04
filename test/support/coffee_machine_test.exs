defmodule CoffeeMachineTest do
  use Behave, file: "test/features/coffee_machine.feature"
  use ExUnit.Case, async: false

  setup do
    {:ok, coffee_machine: CoffeeMachine.new()}
  end

  background do
    given_ "the coffee machine is turned on", %{coffee_machine: coffee_machine} do
      coffee_machine
      |> CoffeeMachine.turn_on()
      |> then(&{:ok, coffee_machine: &1})
    end

    and_ "the water tank is filled", %{coffee_machine: coffee_machine} do
      coffee_machine
      |> CoffeeMachine.fill_water_tank()
      |> then(&{:ok, coffee_machine: &1})
    end

    and_ "the coffee bean container is filled", %{coffee_machine: coffee_machine} do
      coffee_machine
      |> CoffeeMachine.fill_coffee_beans()
      |> then(&{:ok, coffee_machine: &1})
    end
  end

  scenario "brew a single espresso" do
    when_ "I select the \"espresso\" option", %{coffee_machine: coffee_machine} do
      coffee_machine
      |> CoffeeMachine.brew_espresso()
      |> then(&{:ok, coffee_machine: &1})
    end

    then_ "the coffee machine should brew a single espresso", %{
      coffee_machine: coffee_machine
    } do
      assert coffee_machine.finished
    end

    and_ "the coffee machine should display \"Enjoy your espresso\"", %{
      coffee_machine: coffee_machine
    } do
      assert coffee_machine.display == "Enjoy your espresso"
    end
  end

  scenario "brew a double espresso" do
    when_ "I select the \"double espresso\" option", %{coffee_machine: coffee_machine} do
      coffee_machine
      |> CoffeeMachine.brew_double_espresso()
      |> then(&{:ok, coffee_machine: &1})
    end

    then_ "the coffee machine should brew a double espresso", %{
      coffee_machine: coffee_machine
    } do
      assert coffee_machine.finished
    end

    and_ "the coffee machine should display \"Enjoy your double espresso\"", %{
      coffee_machine: coffee_machine
    } do
      assert coffee_machine.display == "Enjoy your double espresso"
    end
  end
end
