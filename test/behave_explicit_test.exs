defmodule BehaveExplicitTest do
  alias Behave.Scenario
  alias Behave
  use ExUnit.Case

  import TestSteps

  test "make coffee explicitly" do
    Scenario.new()
    |> Behave.__given__(&given_coffee_machine/3)
    |> Behave.__given__(&given_it_has_water/3, amount: 259)
    |> Behave.__given__(&given_it_has_coffee/3, cultivar: :crappy_robusta)
    |> Behave.__act__(&act_i_press_the_button/4)
    |> Behave.__check__(&check_it_makes_coffee/4)
    |> Scenario.run()
  end
end
