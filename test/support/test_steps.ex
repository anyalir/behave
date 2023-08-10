defmodule TestSteps do
    import ExUnit.Assertions

    def given_coffee_machine(scenario) do
     put_in(scenario.givens, [{:coffee_machine, CoffeeMachine.new()} | scenario.givens])
    end

    # given :coffee_machine do
    #   {:coffee_machine, CoffeeMachine.new()}
    # end

    # given :coffee_machine, arg do
    #   {:coffee_machine, CoffeeMachine.new(arg)}
    # end

    def given_it_has_water(scenario) do
     update_in(scenario.givens[:coffee_machine], &CoffeeMachine.add_water(&1, 250))
    end
    def given_it_has_coffee(scenario) do
      update_in(scenario.givens[:coffee_machine], &CoffeeMachine.add_coffee(&1, :arabica))
    end
    def when_i_press_the_button(scenario) do
      put_in(scenario.results[:coffee], CoffeeMachine.brew(scenario.givens[:coffee_machine]))
    end
    def then_it_makes_coffee(scenario) do
      assert scenario.results[:coffee] != :disappointment
      scenario |> dbg
    end
end
