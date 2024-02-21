defmodule BehaveExplicitTest do
  alias Behave.Scenario
  alias Behave
  use ExUnit.Case

  import TestSteps

  setup do
    [name: "dsl_coffee_machine"]
  end

  test "make coffee explicitly", args do
    Scenario.new(args)
    |> Behave.__given__(&given_coffee_machine/2)
    |> Behave.__given__(&given_it_has_water/2, amount: 259)
    |> Behave.__given__(&given_it_has_coffee/2, cultivar: :crappy_robusta)
    |> Behave.__act__(&act_i_press_the_button/2)
    |> Behave.__check__(&check_it_makes_coffee/2)
    |> Scenario.run()
  end
end
