defmodule DereferenceDataSteps do
  use Behave.Scenario
  import ExUnit.Assertions

  given "define a random int", name: name do
    {name, Enum.random(1..100)}
  end

  given "read the random int and copy it", %{first: int}, name: name do
    {name, int} 
  end
  
  act "copy data to results", data, name: name do
    {name, data[name]}
  end

  check "the copies are equal", results do 
    assert results.first == results.second
  end

  given "an argumment", value: it do
    {:first, it}
  end

  given "an argument, but the step needs to access data", data, value: it do
    {:second, {data[:first], it}}
  end

  act "read the data, emit results", data do
    {:first_result, data[:first]}
  end

  act "read the data, and an argument, emit results", data, value: it do
    {:second_result, {data[:second], it}} 
  end

  check "results were emitted", results do
    assert results.first_result != nil
    assert results.second_result != nil
  end

  check "we can compare the result to an argument", results, value: it do
    assert results.first_result == it
  end 

  check "we can access the data too", _, data do
    assert data.first != nil
    assert data.second != nil
  end

  check "we can compare the data to an argument", _, data, value: it do
    assert data.first == it
    assert data.second != it
  end

  check "we can compare the data to several arguments", _, data, one: one, two: two, three: three do
    assert data.first == one
    assert data.second == {one, two}
    assert data.first != three
    assert data.second != three
  end

  check "we can compare data and the result to an argument", result, data, value: it do
    assert result.first_result == it
    assert data.first == it  
  end

  check "we can compare data and the result to several arguments", result, data, one: one, two: two, three: three do
    assert result.first_result == one
    assert result.second_result == {{one, two}, three}
    assert data.first == one
    assert data.second == {one, two}
  end
end
