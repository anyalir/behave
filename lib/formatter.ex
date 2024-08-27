defmodule Behave.Formatter do
  use GenServer

  alias Behave.Formatter.Store

  @impl true
  def init(_opts) do
    {:ok, nil}
  end

  @impl true
  def handle_cast({:suite_finished, _suite}, config) do
    Store.create_report()

    {:noreply, config}
  end

  @impl true
  def handle_cast({:test_finished, test}, config) do
    Store.update_status(test)

    {:noreply, config}
  end

  @impl true
  def handle_cast(_, config), do: {:noreply, config}
end
