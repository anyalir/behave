defmodule Formatter.StoreTest do
  use Behave, steps: [Formatter.StoreSteps]
  use ExUnit.Case

  scenario "adding scenarios to store" do
    given "scenario"
    act "call add_scenario"
    check "the store state includes the scenario"
  end

  scenario "setting scenario status" do
    given "scenario"
    given "passed test"
    act "call update_status with passed test"
    check "the scenario has status success"
  end
end
