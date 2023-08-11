defmodule BehaveExplicitTest do
  alias Behave.Scenario
  alias Behave
  use ExUnit.Case

  import TestSteps
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
