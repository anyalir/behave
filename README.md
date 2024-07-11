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
You can run arbitrary code before returning the tuple. If you do not need the `given` steps to produce any values, any return value that is not wrapped in a tuple will be ignored.
In a `given` step, you have access to the values that other `givens` have emitted via the second argument. All macros come with several variants with different arities and guard clauses to access values emitted from previous steps and arguments passed in from the scenario. The arguments are always a keyword list and always the last argument. 

```elixir
# in scenario:

    given "it has water", amount: 250
    
# in step definition:

    given "it has water", data, amount: amount do
      {:coffee_machine, CoffeeMachine.add_water(data.coffee_machine, amount)}
    end

```

Because extracting a value, processing it and then reassigning it to the same kay is a common pattern, there is a shorthand notation for it.
If you pass in a function as the second argument of the tuple, the function will be executed, and the value of the key will be passed in, if it has been set by a prior step.
The value will be overwritten with this function's return value, similar to how `update_in` works.

```elixir

    given "it has water", amount: amount do
      {:coffee_machine, &CoffeeMachine.add_water(&1, amount)}
    end

```

`act` works the same. The main difference is that tuples returned from `act` steps will be assigned to a different map than those from `givens`. This is to separate the prerequisites of a test from its results, and to make comparisons between what was and what is easier.
`act` can accept arguments, just as `given` can.

```elixir

    act "i press the button", data do
      {:coffee, CoffeeMachine.brew(data.coffee_machine)}
    end

```
Note that it is not possible to overwrite values set in `givens`. If you need to modify a value created by a `given`, use a `given`. 

The passed in data is a `Map`. You can also use pattern matching to extract values in a concise way:

```elixir

    given "it has water", %{coffee_machine: it}, amount: amount do
      {:coffee_machine, CoffeeMachine.add_water(it, amount)}
    end

    act "i press the button", %{coffee_machine: it} do
      {:coffee, CoffeeMachine.brew(it)}
    end

```

Finally, run your assertions in a `check` step:

```elixir
    check "it makes coffee", results do
      assert results.coffee != :disappointment
    end
```

`check`s cannot store any values. Their return values are always discarded. However, they have access to both the `data` and `results` maps. 
The values produced in the `act` steps are available in a `check` step through its first argument. 
If you need to access the values emitted in `given`, they are passed in as the second argument.
`data` contains all the values set in `given` steps, and `results` contains the values from the `act` steps.

> Note that `given` and `act` receives `data` as its first argument, but `check` receives `results` as its first argument. This is done to make the common case less verbose to write. 

```elixir
    check "it makes coffee, when given water and coffee", results, data do
      assert results.coffee != :disappointment
      assert data.coffee_machine.water_ml != 0
      assert data.coffee_machine.coffee != nil
    end
```
If you need to access `data`, but not `results`, just assign `data` to `_`:

```elixir
    check "there's still water and coffee in the machine after brewing", _, data do
      assert data.coffee_machine.water_ml != 0
      assert data.coffee_machine.coffee != nil
    end
```

`check` can also accept arguments passed in from the scenario. These are expected to be keyword lists and will always be available as the last argument.

```elixir
    check "it makes the right kind of coffee", results, coffee_variant: variant do
      {:coffee, cup} = results.coffee
      assert cup |> String.contains(variant)
    end

    check "after making coffee, the tank isnt empty", results, data, tolerable_water_remaining: rest_ml do
      assert results.coffee != :disappointment
      assert data.coffee_machine.water_ml >= rest_ml
    end
```

The tests created by the macros are just ExUnit tests.
To run your tests, just `mix test` them 🎉

## Migrating from 0.1.x

* It is no longer necessary to return `:ignore` from `given` and `act`. Any value returned that is not wrapped in a tuple will be discarded.
* The implicitly-available `data` and `results` variables no longer exist. You now have to explicitly state that you want to access them in the arguments to a step. 
* If you want to access a value from an earlier `given` in a `given` step, you no longer _have_ to use a lambda. You still can, as a shorthand, but it's no longer the only or preferred way. This should reduce the need to wrap the values emitted in `given` steps in further maps as well as "hacky" solutions making use of lambdas to access one key and emit into another.

### How to refactor

1) find all usages of `data` and `results`, and explicitly add them to the step arguments. 
2) Any arguments you already have there, passing in values from the scenarios, should be in the form of a keyword list and always in the last position. Passing in anything but a keyword list will not work, but the macros are smart enough to figure out if you want to access any combination of `data`, `results` and scenario arguments.
3) Optionally, get rid of any hacks to work around not having access to `data` in `givens`. Those are still supported, but no longer necessary.

## Installation

The package is available on [hex.pm](https://hex.pm/packages/behave_bdd) and can be installed
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

