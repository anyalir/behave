defmodule Formatter.StoreSteps do
  use Behave.Scenario
  import ExUnit.Assertions

  alias Behave.Formatter.Store
  alias Behave.Formatter.Scenario

  given "scenario" do
    scenario = %Scenario{title: "example"}

    {:scenario, scenario}
  end

  given "passed test" do
    test = %ExUnit.Test{
      name: :"test example",
      case: Formatter.StoreTest,
      module: Formatter.StoreTest,
      state: nil,
      time: 3,
      tags: %{
        async: false,
        line: 5,
        module: Formatter.StoreTest,
        registered: %{},
        file: "/home/aron/clark/behave/test/formatter/store_test.exs",
        test: :"test example",
        test_type: :test,
        describe_line: nil,
        describe: nil
      },
      logs: ""
    }

    {:test, test}
  end

  act "call add_scenario", data do
    {:add_scenario_result, Store.handle_cast({:add_scenario, data.scenario}, %{})}
  end

  act "call update_status with passed test", data do
    update_status_result  =
      Store.handle_cast(
        {:update_status, data.test},
        %{ data.scenario.title => data.scenario }
      )

    {:update_status_result, update_status_result}
  end

  check "the store state includes the scenario", result, data do
    title = data.scenario.title
    scenario = data.scenario

    assert {:noreply, %{^title => ^scenario}} = result.add_scenario_result
  end

  check "the scenario has status success", result, data do
    title = data.scenario.title

    assert {:noreply, %{^title => %{status: :success}}} = result.update_status_result
  end
end
