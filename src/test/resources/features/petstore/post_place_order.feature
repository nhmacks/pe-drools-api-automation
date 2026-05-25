@smoke
Feature: Place Order in Petstore API
  As a consumer of the API
  I want to be able to place an order for a pet in the Petstore

  @po001 @smoke
  Scenario Outline: Place a new order for a pet
    When the "customer" places an order with the following data:
      | id        | petId | quantity | shipDate             | status   | complete |
      |<id>       |<petId>|<quantity>|<shipDate>            |<status>  |<complete>|
    Then the response status should be 200
    And the order id in the response should be <id>
    And the petId in the response should be <petId>
    And the quantity in the response should be <quantity>
    And the shipDate in the response should be "<shipDate>"
    And the status in the response should be "<status>"
    And the complete flag in the response should be "<complete>"

    Examples: happy and edge cases
      | id         | petId | quantity | shipDate                      | status     | complete |
      | 1          | 1     | 2        | 2026-01-08T02:55:10.556+0000  | placed     | true     |
      | 1234       | 2     | 1        | 2024-06-16T11:30:00.556+0000  | approved   | false    |
      | 12347      | 3     | 5        | 2024-06-17T09:15:00.556+0000  | delivered  | true     |
      | 1000000000 | 10    | 0        | 2026-01-08T02:55:10.556+0000  | placed     | false    |


    @po002 @negative
      Scenario: data type validation for order fields
        When the "customer" places an order with the following data:
          | id        | petId | quantity | shipDate             | status   | complete |
          | abcde     | xyz   | two      | invalid-date         | unknown  | notbool  |
        Then the response status should be 500
        And the response should contain error messages indicating invalid data types for each field
