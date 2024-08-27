defmodule Behave.Formatter.HtmlRenderer do
  def create_html_report(scenarios) do
    File.write(report_name(), render(scenarios))
  end

  def report_name do
    Application.get_env(:behave, :report_name, "behave.html")
  end

  defp render(scenarios) do
    EEx.eval_string(template(), scenarios: scenarios)
  end

  defp template do
    """
    <head>
      <title>Behave report</title>
    </head>
    <body>
      <h1>Behave report</h1>
      <ul>
        <%= for scenario <- scenarios do %>
          <li class="<%= to_string(scenario.status) %>"><%= scenario.title %> [<%= scenario.status %>]</li>
          <ul class="<%= to_string(scenario.status) %>">
            <%= for step <- scenario.steps do %>
              <li><%= to_string(step.action) %> <%= step.title %> <%= step.params |> Enum.map(&inspect(&1)) |> Enum.join(", ") %></li>
            <% end %>
          </ul>
        <% end %>
      </ul>
      <style>
        .success {
          color: DarkGreen;
        }
        .failed {
          color: DarkRed;
        }
      </style>
    </body>
    """
  end
end
