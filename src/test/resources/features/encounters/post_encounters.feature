@encounters
Feature: Encounters
  Como consumidor del API
  Quiero poder registrar encounters con sus servicios
  Para procesar la facturacion de prestaciones medicas

  @enc001 @smoke @happy-path
  Scenario Outline: Registrar un encounter con un servicio ambulatorio
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador | importe_total | tipo_encounter | empresa | sede |
      | CASE-NECESARIOS-001 | 1174        | 100           | AMBULATORIO    | 12      | 14   |
    And contiene el siguiente servicio:
      | order_id   | sede   | ambito   | financiador   | producto   | plan   | beneficio   | codigo_autorizacion   | tipo_encounter   | codigo_prestacion   | importe   | cantidad   | empresa   |
      | <order_id> | <sede> | <ambito> | <financiador> | <producto> | <plan> | <beneficio> | <codigo_autorizacion> | <tipo_encounter> | <codigo_prestacion> | <importe> | <cantidad> | <empresa> |
    And envia la solicitud al endpoint de encounters
    Then el estado de respuesta debe ser 200
    And la respuesta contiene el encounter_id "CASE-NECESARIOS-001"
    And el encounter tiene 1 servicio
    And el encounter tiene 0 documentos necesarios
    And el encounter tiene 0 documentos reemplazables
    And el servicio 1 en la respuesta tiene order_id <order_id>
    And el servicio 1 en la respuesta tiene codigo_prestacion "<codigo_prestacion>"
    And el servicio 1 en la respuesta tiene importe <importe>
    And el servicio 1 tiene 0 documentos necesarios
    And el servicio 1 tiene 0 documentos reemplazables

    Examples:
      | order_id | sede | ambito | financiador | producto | plan | beneficio | codigo_autorizacion | tipo_encounter | codigo_prestacion | importe | cantidad | empresa |
      | 1        | 4    | 1      | 19          | 1437     | 963  |           | FICTICIO            | AMBULATORIO    | 50201             | 1500    | 1        | 12      |