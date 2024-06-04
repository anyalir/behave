defmodule CoffeeMachine do
  @moduledoc """
  A simulation of a coffee machine.
  The coffee machine is modeled as a finite state machine, just to have some code to run simulated tests against.
  """

  defstruct [
    :power,
    :water_tank,
    :coffee_beans,
    :needs_cleaning,
    :finished,
    :display
  ]

  def new() do
    %CoffeeMachine{
      power: :off,
      water_tank: :empty,
      coffee_beans: :empty,
      needs_cleaning: false,
      finished: false,
      display: ""
    }
  end

  def turn_on(machine) do
    %{machine | power: :on, display: "Coffee machine is on"}
  end

  def turn_off(machine) do
    %{machine | power: :off, display: "Goodbye"}
  end

  def fill_water_tank(machine) do
    %{machine | water_tank: :full, display: "Water tank filled"}
  end

  def fill_coffee_beans(machine) do
    %{machine | coffee_beans: :full, display: "Coffee beans filled"}
  end

  def clean(machine) do
    %{machine | needs_cleaning: false, display: "Cleaning complete"}
  end

  def brew_espresso(machine)
      when machine.water_tank == :full and machine.coffee_beans == :full do
    %{machine | display: "Enjoy your espresso", finished: true}
  end

  def brew_espresso(machine) do
    %{machine | display: "Can't brew a coffee, please fill water and coffe beans"}
  end

  def brew_double_espresso(machine)
      when machine.water_tank == :full and machine.coffee_beans == :full do
    %{machine | display: "Enjoy your double espresso", finished: true}
  end

  def brew_double_espresso(machine) do
    %{machine | display: "Can't brew a coffee, please fill water and coffe beans"}
  end

  def needs_cleaning?(machine), do: machine.needs_cleaning
end
