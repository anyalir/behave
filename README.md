# Behave
> Behaviour driven development for ExUnit with product management friendly readable scenarios.

![Behave, baby, behave!](https://i.giphy.com/3o7bu1iM5MSwG2y7NS.gif)

## Features

* Minimal DSL on top of ExUnit.
* `given_`, `when_`, `then_`, `and_` and `but_` are the available keywords (the trailing underscore toavoid naming collisions).
* `Background` are supported.
* Tags are supported.
* Leverage the BDD, as your feature is guiding the process.
* Steps are just functions, scenarios are just ExUnit tests.

## Usage

Let your product folks creates the required features with the goods of Gherkin syntax.

```Gherkin
Feature: coffee machine
  Scenario make coffee
    Given the coffee machine is turned on
    When I select the "espresso" option
    Then the coffee machine should brew a single espresso
```
To fulfill this required feature you need to create a testing file.

```elixir
defmodule CoffeeMachineTest do
  use ExUnit.Case
  use Behave, file: "coffee_machine.feature"
end

```

Notice we're passing `:file` to `Behave`, this is the gherkin file where you define your test feature.

Then, use the `Behave` DSL to implement your feature.

```elixir
defmodule MyCoffeeMachineTest do
  use ExUnit.Case
  use Behave, file: "coffee_machine.feature"

  scenario "make coffee" do
    given_ "the coffee machine is turned on" do: # something
    when_ "I select the \"espresso\" option" do: # something
    then_ "the coffee machine should brew a single espresso" do: # something
  end
end
```

Your test suite now ready to go as part of your ExUnit tests.
The previous example shows the minimal feature of `Behave` now let's explore the beauty. Since `Behave` now support most of the Gherkin features.
But in real world sceanrio it should look like this

```Gherkin
# -- coffee_machine.feature
@new @features
Feature: coffee machine
  If you love coffee, you definitly need one at home, when you can enjoy
  your passion, and a decent coffee machine should provide certain functionality.

  Background:
    Given the coffee machine is turned on
    And the water tank is filled
    And the coffee bean container is filled

  Scenario: brew a single espresso
    When I select the "espresso" option
    Then the coffee machine should brew a single espresso
    And the coffee machine should display "Enjoy your espresso"

  Scenario: brew a double espresso
    When I select the "double espresso" option
    Then the coffee machine should brew a double espresso
    And the coffee machine should display "Enjoy your double espresso"
```

### Tags
Behave supports tags from the Gherkin file, all the defined tag will be appended to the scenario test case.
so if you run your tests for a specific tags, this will apply on Behave test cases

```bash
 $ mix test
..
Finished in 0.03 seconds (0.00s async, 0.03s sync)
2 scenarios, 0 failures
```
### Background
Behave support background, so if you have a repeated preparation steps for scenario, use backgrounds and the included steps will runs before each scenario.
```elixir
  background do
    given_ "the coffee machine is turned on" do: # something
    and_ "the water tank is filled" do: # something
    and_ "the coffee bean container is filled" do: # something
  end
  ```
### Keywords
`given_`, `when_`, `then_`, `and_` and `but_` are all available from the Gherkin style, it's a defined functions, that accepts variable from ExUnit context.

```elixir
  given_ "the coffee machine is turned on", %{coffee_machine: coffee_machine} do
    coffee_machine
    |> CoffeeMachine.turn_on()
    |> then(&{:ok, coffee_machine: &1})
  end
```
The given context is the same available over all the `scenario` scope will be taken from the ExUnit setup.
```elixir
  setup do
    {:ok, coffee_machine: CoffeeMachine.new()}
  end
```
and if you willing to change the context or to append a new variables you need to return a successful tuple
```elixir
{:ok, coffee_machine: coffee_machine, message: message}
```
Then the new state will be available for the next step.

>All that said and done, just run your test like any ExUnit test 🎉


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `behave_bdd` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:behave_bdd, "~> 0.2.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/behave_bdd>.
