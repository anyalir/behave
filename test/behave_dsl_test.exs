defmodule BehaveDslTest do
  use Behave, steps: [TestSteps]
  use ExUnit.Case

  scenario "make coffee with dsl" do
    given "coffee machine"
    given "it has water", amount: 250
    given "it has coffee", cultivar: :java
    act "i press the button"
    check "it makes coffee"
  end
end
