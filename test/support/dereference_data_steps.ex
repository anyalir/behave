defmodule DereferenceDataSteps do
  use Behave.Scenario
  import ExUnit.Assertions

  given "define a random int", name: name do
    {name, Enum.random(1..100)}
  end

  given "read the random int and copy it", %{first: int}, name: name do
    {name, int} 
  end
  
  act "copy data to results", name: name do
    {name, data[name]}
  end

  check "the copies are equal" do 
    assert results.first == results.second
  end

end
