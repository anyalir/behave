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

  scenario "make coffee with different arities" do
    given "coffee machine"
    given "it has water and coffee", amount: 500, cultivar: :kopi_luwak
    act "i press the button"
    check "it makes coffee"
  end
end
