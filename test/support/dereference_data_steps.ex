defmodule DereferenceDataSteps do
  use Behave.Scenario
  import ExUnit.Assertions

  given "define a random int", %{args: [name: name]} do
    {name, Enum.random(1..100)}
  end

  given "read the random int and copy it", %{args: [name: name], data: %{first: int}} do
    {name, int} 
  end
  
  act "copy data to results", %{args: [name: name], data: data} do
    {name, data[name]}
  end

  check "the copies are equal", %{results: results} do 
    assert results.first == results.second
  end

end
