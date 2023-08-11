# Behave
> Behaviour driven development for ExUnit with product management friendly readable scenarios.

![Behave, baby, behave!](https://i.giphy.com/3o7bu1iM5MSwG2y7NS.gif)

## Features

* Minimal DSL on top of ExUnit.
* given, act, check instead of given, when, then to avoid naming collisions.
* Api can be used without macros, if necessary
* Steps are just functions, scenarios are just ExUnit tests.
* Not a full gherkin implementation, it just gives you the ability to decompose tests into reusable named steps.
* Separate DSLs for defining scenarios and implementing test steps.
* Dependency Free. Use whatever assertion, mocking and testing libraries you want.

## Usage

Assuming you have a BDD stlye scenario like this:

```Gherkin
Scenario make coffee
  Given a coffee machine
  And it has 250 ml of water in its tank
  And it has java coffee beans in its reservoir
  When i press the "make coffee" button
  Then it makes coffee
```

In your ExUnit test, use the `Behave` module:

```elixir
defmodule MyCoffeeMachineTest do
  use ExUnit.Case
  use Behave, steps: [MyCoffeeMachineTestSteps]

  ...
end

```

Notice we're passing `:steps` to `Behave`, this is the module where you define your test steps.

Then, use the `Behave` DSL to implement your scenario:

```elixir
defmodule MyCoffeeMachineTest do
  use ExUnit.Case
  use Behave, steps: [MyCoffeeMachineTestSteps]

  scenario "make coffee with dsl" do
    given "coffee machine"
    given "it has water", amount: 250
    given "it has coffee", cultivar: :java
    act "i press the button"
    check "it makes coffee"
  end
end
```

Your `TestSteps` modules should be defined in a directory that gets picked up by the compiler, such as `test/support`.
In those modules, you need to define a step function for each test step (given, act, check).

```elixir
defmodule TestSteps do
    use Behave.Scenario # for access to the step definition DSL
    import ExUnit.Assertions

    given "coffee machine" do
      {:coffee_machine, CoffeeMachine.new()}
    end

    ...
end
```

The `given` macro expects you to return a tuple of an atom that will be used to refer to the returned value, and the value that should be available to subsequent steps.
You can run arbitrary code before returning the tuple. If you do not need the `given` steps to produce any values, return `:ignore` instead.
This is useful if you want to execute a `given` just for it's side effects. Note that you cannot just return `:nil`.

`given` s can take arguments, too: 

```elixir
# in scenario:

    given "it has water", amount: 250
    
# in step definition:

    given "it has water", amount: amount do
      {:coffee_machine, &CoffeeMachine.add_water(&1, amount)}
    end

```

If you pass in a function as the second argument of the tuple, it will execute the function and pass in the value of the key, if it has been set by a prior step.
The value will be overwritten with this function's return value, similar to how `update_in` works.

`act` works similarly, but the keys it returns will be separated from the keys that the `given` steps have prepared. `act` also has access to all values set in prior
givens through an injected `data` map:

```elixir
    act "i press the button" do
      {:coffee, CoffeeMachine.brew(data.coffee_machine)}
    end
```

Note that it is not possible to overwrite values set in `givens`. If you need to modify a value created by a `given`, use a `given`. 
`act` can accept arguments, just as `given` can.

Finally, run your assertions in a `check` step:

```elixir
    check "it makes coffee" do
      assert results.coffee != :disappointment
    end
```

`check`s cannot store any values. Their return values are always discarded. However, they have access to both the `data` and `results` maps. 
`data` contains all the values set in `given` steps, and `results` contains the values from the `act` steps.
`check` can accept arguments as well.

All that said and done, just run your test like any ExUnit test 🎉


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `behave_bdd` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:behave_bdd, "~> 0.1.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/behave_bdd>.

