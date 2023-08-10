defmodule BehaveTest do
  alias LSP.Types.SelectionRange
  alias Behave.Scenario
  use Behave
  use ExUnit.Case

  import TestSteps

   scenario "make coffee with dsl" do
    given &given_coffee_machine/2
    given &given_it_has_water/2, [250]
    given &given_it_has_coffee/2, [:java]
    act &when_i_press_the_button/2
    check &then_it_makes_coffee/2
   end

  test "make coffee explicitly" do
    scenario = Scenario.new()
    scenario = Behave.__given__(scenario, &given_coffee_machine/2)
    scenario = Behave.__given__(scenario, &given_it_has_water/2, [250])
    scenario = Behave.__given__(scenario, &given_it_has_coffee/2, [:java])
    scenario = Behave.__act__(scenario, &when_i_press_the_button/2)
    scenario = Behave.__check__(scenario, &then_it_makes_coffee/2)
    Scenario.run(scenario)
  end

  # scenario "make coffee" do
  #   given "coffee_machine"
  #   given "it has water"
  #   given "it coffee water"
  #   When "i press the button"
  #   Then "it makes coffee"
  # end
end
