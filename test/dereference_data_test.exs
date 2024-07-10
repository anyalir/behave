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
  
  scenario "extended DSL" do
    given "an argumment", value: :foo
    given "an argument, but the step needs to access data", value: :bar
    act "read the data, emit results"
    act "read the data, and an argument, emit results", value: :baz
    check "results were emitted"
    check "we can compare the result to an argument", value: :foo
    check "we can access the data too"
    check "we can compare the data to an argument", value: :foo
    check "we can compare the data to several arguments", one: :foo, two: :bar, three: :baz
    check "we can compare data and the result to an argument", value: :foo
    check "we can compare data and the result to several arguments", one: :foo, two: :bar, three: :baz
  end
end
