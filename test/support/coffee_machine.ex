defmodule CoffeeMachine do
  @moduledoc """
  A simulation of a coffee machine.
  The coffee machine is modeled as a finite state machine, just to have some code to run simulated tests against.
  """
  defstruct coffee: nil, water_ml: 0

  @spec new :: %CoffeeMachine{coffee: nil, water_ml: 0}
  def new, do: %__MODULE__{}

  @spec add_water(%CoffeeMachine{}, number) :: %CoffeeMachine{}
  def add_water(machine = %__MODULE__{}, amount) when is_number(amount) do
    update_in(machine.water_ml, &(&1 + amount))
  end

  @spec add_coffee(%CoffeeMachine{}, atom) :: %CoffeeMachine{}
  def add_coffee(machine = %__MODULE__{}, grounds) when is_atom(grounds) do
    put_in(machine.coffee, grounds)
  end

  @spec brew(%CoffeeMachine{:coffee => atom(), :water_ml => number()}) ::
          :disappointment | {:coffee, <<_::64, _::_*8>>}
  def brew(machine = %__MODULE__{}) do
    if machine.coffee != nil && machine.water_ml > 0 do
      {:coffee, "A steaming hot cup of #{machine.coffee}. Enjoy!"}
    else
      :disappointment
    end
  end
end
