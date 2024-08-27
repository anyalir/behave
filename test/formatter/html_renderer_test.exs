defmodule Formatter.HtmlRendererTest do
  use Behave, steps: [Formatter.HtmlRendererSteps]
  use ExUnit.Case

  scenario "the formatter renders correctly the html" do
    given "scenarios"
    act "call create_html_report/1"
    check "create correct html report"
  end
end
