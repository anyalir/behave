defmodule BehaveTest do
  alias LSP.Types.SelectionRange
  alias Behave.Scenario
  use Behave
  use ExUnit.Case

  import TestSteps

  # scenario "make coffee" do
  #   given_coffee_machine
  #   |> given_it_has_water
  #   |> given_it_has_coffee
  #   |> when_i_press_the_button
  #   |> then_it_makes_coffee
  #   |> Behave.Scenario.run
  # end

  test "make coffee explicitly" do
    scenario = Scenario.new()
    scenario = Behave.__given__(scenario, &given_coffee_machine/1)
    scenario = Behave.__given__(scenario, &given_it_has_water/1)
    scenario = Behave.__given__(scenario, &given_it_has_coffee/1)
    scenario = Behave.__when__(scenario, &when_i_press_the_button/1)
    scenario = Behave.__then__(scenario, &then_it_makes_coffee/1)
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
