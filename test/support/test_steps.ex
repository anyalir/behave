defmodule TestSteps do
    use Behave.Scenario
    import ExUnit.Assertions

    # def given_coffee_machine(scenario, _args) do
    #  put_in(scenario.data, [{:coffee_machine, CoffeeMachine.new()} | scenario.data])
    # end

    given "coffee machine" do
      {:coffee_machine, CoffeeMachine.new()}
    end

    given "it has water", amount: amount do
      {:coffee_machine, &CoffeeMachine.add_water(&1, amount)}
    end

    given "it has coffee", cultivar: cultivar do
      {:coffee_machine, &CoffeeMachine.add_coffee(&1, cultivar)}
    end
    def act_i_press_the_button(scenario, _args) do
      put_in(scenario.results[:coffee], CoffeeMachine.brew(scenario.data[:coffee_machine]))
    end
    def check_it_makes_coffee(scenario, _args) do
      assert scenario.results[:coffee] != :disappointment
      scenario |> dbg
    end
end
