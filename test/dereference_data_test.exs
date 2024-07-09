defmodule DereferenceDataTest do
  use Behave, steps: [DereferenceDataSteps]
  use ExUnit.Case

  scenario "givens that depend on one another" do
    given "define a random int", name: :first
    given "read the random int and copy it", name: :second
    act "copy data to results", name: :first
    act "copy data to results", name: :second
    check "the copies are equal"
  end
end
