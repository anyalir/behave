
# -- coffee_machine.feature
@new @features
Feature: coffee machine
  If you love coffee, you definitly need one at home, when you can enjoy
  your passion, and a decent coffee machine should provide certain functionality.

  Background:
    Given the coffee machine is turned on
    And the water tank is filled
    And the coffee bean container is filled

  Scenario: brew a single espresso
    When I select the "espresso" option
    Then the coffee machine should brew a single espresso
    And the coffee machine should display "Enjoy your espresso"

  Scenario: brew a double espresso
    When I select the "double espresso" option
    Then the coffee machine should brew a double espresso
    And the coffee machine should display "Enjoy your double espresso"
