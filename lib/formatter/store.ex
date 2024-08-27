defmodule Behave.Formatter.Store do
  use GenServer

  alias Behave.Formatter.HtmlRenderer

  @impl true
  def init(_opts) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:add_scenario, scenario}, state) do
    new_state = Map.put(state, scenario.title, scenario)

    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:update_status, test}, state) do
    state = update_state_for_test(state, test)

    {:noreply, state}
  end

  @impl true
  def handle_call(:create_report, _from, state) do
    state
    |> Enum.map(&elem(&1, 1))
    |> HtmlRenderer.create_html_report()

    {:reply, :ok, state}
  end

  def add_scenario(scenario) do
    cast(:add_scenario, scenario)
  end

  def update_status(test) do
    cast(:update_status, test)
  end

  def create_report() do
    call(:create_report)
  end

  def cast(action, params) do
    GenServer.cast(__MODULE__, {action, params})
  end

  def call(action) do
    GenServer.call(__MODULE__, action)
  end

  def start do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  defp test_status(test) do
    if test.state do
      elem(test.state, 0)
    else
      :success
    end
  end

  defp update_state_for_test(state, test) do
    entry =
      Enum.find(state, fn {title, _scenario} ->
        String.contains?(to_string(test.name), title)
      end)

    if entry do
      entry
      |> elem(1)
      |> Map.replace!(:status, test_status(test))
      |> then(&Map.put(state, &1.title, &1))
    else
      state
    end
  end
end
