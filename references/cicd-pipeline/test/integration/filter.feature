Feature: MockTarget API all endpoints
  As an API consumer
  I want to list all apis paths for MockTarget
  So that I can ensure the api is working.

  Scenario: I should be Authenticate into the mock
    When I GET /auth
    Then response code should be 200

  Scenario: I should be able to get JSON response
    When I GET /json
    Then response code should be 200
    And response body path $.firstName should be John
    And response body path $.lastName should be Doe

  Scenario: I should be able to get XML response
    When I GET /xml
    Then response code should be 200

  Scenario: I should find all key=value in body
    When I GET /echo?key=value
    Then response code should be 200
    And response body path $.url should be /?key=value

  Scenario: I should be able to get ip address from mock
    When I GET /ip
    Then response code should be 200