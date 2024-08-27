defmodule Formatter.HtmlRendererSteps do
  use Behave.Scenario
  import ExUnit.Assertions

  alias Behave.Formatter.HtmlRenderer
  alias Behave.Formatter.Scenario
  alias Behave.Formatter.Step

  given "scenarios" do
    scenarios = [
      %Scenario{
        title: "make coffee with different arities",
        status: :success,
        steps: [
          %Step{action: :given, title: "coffee machine", params: []},
          %Step{
            action: :given,
            title: "it has water and coffee",
            params: [[amount: 500, cultivar: :kopi_luwak]]
          },
          %Step{
            action: :act,
            title: "i press the button",
            params: []
          },
          %Behave.Formatter.Step{action: :check, title: "it makes coffee", params: []}
        ]
      },
      %Behave.Formatter.Scenario{
        title: "make coffee with dsl",
        status: :failed,
        steps: [
          %Step{action: :given, title: "coffee machine", params: []},
          %Step{
            action: :given,
            title: "it has water",
            params: [[amount: 250]]
          },
          %Step{
            action: :given,
            title: "it has coffee",
            params: [[cultivar: :java]]
          },
          %Step{
            action: :act,
            title: "i press the button",
            params: []
          },
          %Step{action: :check, title: "it makes coffee", params: []}
        ]
      }
    ]

    {:scenarios, scenarios}
  end

  act "call create_html_report/1", data do
    HtmlRenderer.create_html_report(data.scenarios)
  end

  check "create correct html report" do
    assert {:ok, html} = File.read(HtmlRenderer.report_name())

    assert html =~ "make coffee with different arities"
    assert html =~ "it has water and coffee"
    assert html =~ "success"

    assert html =~ "make coffee with dsl"
    assert html =~ "fail"
  end
end
