@smoke
Feature: Get Order from Petstore API
  As a consumer of the API
  I want to retrieve orders by id and validate responses

  @go001 @happy
  Scenario Outline: Retrieve an existing order by id
    Given the order exists with:
      | id   | petId   | quantity   | shipDate   | status   | complete   |
      | <id> | <petId> | <quantity> | <shipDate> | <status> | <complete> |
    When the client requests order with id "<id>"
    Then the response status should be 200
    And the response should include the order identifier <id>
    And the response should include the associated pet identifier <petId>
    And the response should include the ordered quantity <quantity>
    And the response should include the shipping date "<shipDate>"
    And the response should include the order status "<status>"
    And the response should indicate whether the order is completed "<complete>"

    Examples:
      | id     | petId | quantity | shipDate                     | status    | complete |
      | 2      | 5     | 3        | 2024-06-15T10:00:00.556+0000 | delivered | true     |
      | 9999   | 8     | 9999     | 2024-06-16T12:30:00.123+0000 | placed    | false    |
      | 999999 | 12    | 999999   | 2024-06-17T15:45:00.789+0000 | approved  | true     |

  @go002 @unhappy
  Scenario: Request a non-existing order returns 404
    Given the order does not exist with id "99999999999"
    When the client requests order with id "99999999999"
    Then the response status should be 404
    And the response should indicate order not found

  @go003 @unhappy
  Scenario Outline: Invalid id formats should return appropriate error codes
    Given the order does not exist with id "<id>"
    When the client requests order with id "<id>"
    Then the response status should be <expectedStatus>
    And the response should include error type "<type>"
    And the response should include error message "<message>"
    Examples:
      | id   | expectedStatus | type    | message                                                     |
      | abc  | 404            | unknown | java.lang.NumberFormatException: For input string: \"abc\"  |
      | 1.23 | 404            | unknown | java.lang.NumberFormatException: For input string: \"1.23\" |
      | -5   | 404            | error   | Order not found                                             |

