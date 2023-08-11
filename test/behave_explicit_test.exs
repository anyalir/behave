defmodule BehaveExplicitTest do
  alias Behave.Scenario
  alias Behave
  use ExUnit.Case

  import TestSteps
  test "make coffee explicitly" do
    Scenario.new()
    |> Behave.__given__(&given_coffee_machine/2)
    |> Behave.__given__(&given_it_has_water/2, amount: 259)
    |> Behave.__given__(&given_it_has_coffee/2, cultivar: :crappy_robusta)
    |> Behave.__act__(&act_i_press_the_button/2)
    |> Behave.__check__(&check_it_makes_coffee/2)
    |> Scenario.run()
  end
end
