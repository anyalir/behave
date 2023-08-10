defmodule BehaveTest do
  alias Behave.Scenario
  use Behave
  use ExUnit.Case

  import TestSteps

   scenario "make coffee with dsl" do
    given "coffee machine"
    given "it has water", amount: 250
    given "it has coffee", cultivar: :java
    act "i press the button"
    check "it makes coffee"
   end

  test "make coffee explicitly" do
    scenario = Scenario.new()
    scenario = Behave.__given__(scenario, &given_coffee_machine/2)
    scenario = Behave.__given__(scenario, &given_it_has_water/2, amount: 259)
    scenario = Behave.__given__(scenario, &given_it_has_coffee/2, cultivar: :crappy_robusta)
    scenario = Behave.__act__(scenario, &act_i_press_the_button/2)
    scenario = Behave.__check__(scenario, &check_it_makes_coffee/2)
    Scenario.run(scenario)
  end
end
