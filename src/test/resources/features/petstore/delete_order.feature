@smoke
Feature: Delete Order from Petstore API
  As a consumer of the API
  I want to be able to delete orders by id and validate responses

  @do001 @happy
  Scenario Outline: Delete an existing order by id

    Given the order exists with:
      | id   | petId   | quantity   | shipDate   | status   | complete   |
      | <id> | <petId> | <quantity> | <shipDate> | <status> | <complete> |
    When the client deletes order with id "<id>"
    Then the response status should be 200
    And the client requests order with id "2"
    Then the response status should be 404
    And the response should indicate order not found
    Examples:
      | id | petId | quantity | shipDate                     | status    | complete |
      | 2  | 5     | 3        | 2024-06-15T10:00:00.556+0000 | delivered | true     |

  @do002 @unhappy
  Scenario: Delete a non-existing order returns 404
    Given the order does not exist with id "99999999909"
    When the client deletes order with id "99999999909"
    Then the response status should be 404
    And the response should indicate order not found 404

  @do003 @unhappy
  Scenario Outline: Invalid id formats should return appropriate error codes
    Given the order does not exist with id "<id>"
    When the client deletes order with id "<id>"
    Then the response status should be <expectedStatus>
    And the response should include error type "<type>"
    And the response should include error message "<message>"

    Examples:
      | id   | expectedStatus | type    | message                                                     |
      | abc  | 404            | unknown | java.lang.NumberFormatException: For input string: \"abc\"  |
      | 1.23 | 404            | unknown | java.lang.NumberFormatException: For input string: \"1.23\" |
      | -5   | 404            | unknown | Order Not Found                                             |

  # Nota: ajusta expectedStatus según el comportamiento real de la API si difiere.

