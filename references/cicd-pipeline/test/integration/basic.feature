Feature: MockTarget API
  As an API consumerI should be able to run below APIs

  Scenario: I should be able to get the default Endpoint
    When I GET /
    Then response code should be 200

  Scenario: I should receive a 404 error for non-existing API Path
    When I GET /asas
    Then response code should be 404
