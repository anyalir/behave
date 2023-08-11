defmodule TestSteps do
    use Behave.Scenario
    import ExUnit.Assertions

    # def given_coffee_machine(scenario, _args) do
    #  put_in(scenario.data, [{:coffee_machine, CoffeeMachine.new()} | scenario.data])
    # end

    given "coffee machine" do
      {:coffee_machine, CoffeeMachine.new()}
    end

    # given :coffee_machine, arg do
    #   {:coffee_machine, CoffeeMachine.new(arg)}
    # end

    def given_it_has_water(scenario, amount: amount) do
     update_in(scenario.data[:coffee_machine], &CoffeeMachine.add_water(&1, amount))
    end
    def given_it_has_coffee(scenario, cultivar: cultivar) do
      update_in(scenario.data[:coffee_machine], &CoffeeMachine.add_coffee(&1, cultivar))
    end
    def act_i_press_the_button(scenario, _args) do
      put_in(scenario.results[:coffee], CoffeeMachine.brew(scenario.data[:coffee_machine]))
    end
    def check_it_makes_coffee(scenario, _args) do
      assert scenario.results[:coffee] != :disappointment
      scenario |> dbg
    end
end
