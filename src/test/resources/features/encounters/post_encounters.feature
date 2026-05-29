@encounters
Feature: Encounters
  Como consumidor del API
  Quiero poder registrar encounters con sus servicios
  Para procesar la facturacion de prestaciones medicas

  @enc001 @smoke @happy-path
  Scenario Outline: RULE 1  Código de autorización inválido (critical exclude)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador | importe_total | tipo_encounter   | empresa | sede |
      | CASE-NECESARIOS-001 | 174         | 1500          | <tipo_encounter> | 12      | 4    |
    And contiene el siguiente servicio:
      | order_id | empresa | sede | producto | beneficio | codigo_autorizacion   | codigo_prestacion | importe | cantidad |
      | 1        | 12      | 4    | 1437     | 350       | <codigo_autorizacion> | APA00005          | 1500    | 1        |
    And envia la solicitud al endpoint de encounters
    Then el estado de respuesta debe ser 200
    And la respuesta contiene el encounter_id "CASE-NECESARIOS-001"
    And el encounter tiene 1 servicio
    And el encounter tiene 0 documentos necesarios
    And el encounter tiene 0 documentos reemplazables
    And el servicio 1 en la respuesta tiene order_id 1
    And el servicio 1 en la respuesta tiene codigo_prestacion "APA00005"
    And el servicio 1 en la respuesta tiene importe 1500
    And el servicio 1 tiene 0 documentos necesarios
    And el servicio 1 tiene 0 documentos reemplazables

    Examples:
      | codigo_autorizacion | tipo_encounter |
      | PREOPERATORIO       | AMBULATORIO    |
      | FICTICIO            | EMERGENCIA     |
      | CAMPAÑA             | AMBULATORIO    |
      | SIN ATENCIÓN        | EMERGENCIA     |
      | PILOTO              | AMBULATORIO    |


  @enc002 @smoke @happy-path
  Scenario Outline: RULE 2  Matriz financiador (Hipermercados Tottus)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa | sede |
      | CASE-NECESARIOS-001 | <financiador> | 1500          | <tipo_encounter> | 12      | 4    |
    And contiene el siguiente servicio:
      | order_id | empresa | sede | producto   | beneficio    | codigo_autorizacion | codigo_prestacion | importe | cantidad |
      | 1        | 12      | 4    | <producto> | (cualquiera) | PILOTO              | ECO00110          | 1500    | 1        |
    And envia la solicitud al endpoint de encounters
    Then el estado de respuesta debe ser 200
    And la respuesta contiene el encounter_id "CASE-NECESARIOS-001"
    And el servicio 1 en la respuesta tiene codigo_prestacion "ECO00110"
    And el servicio 1 en la respuesta tiene importe 1500
    And el encuentro indica como documentos necesario "<documents>"

    Examples:
      | financiador | producto | tipo_encounter | documents | document_groups |
      | 1174        | 1447     | AMBULATORIO    | 2         |                 |
      | 1171        | 1440     | AMBULATORIO    |           | 002, 010        |
      | 1164        | 1448     | AMBULATORIO    | 2         |                 |
      | 1137        | 1346     | AMBULATORIO    | 2         |                 |
      | 1140        | 1434     | AMBULATORIO    | 037, 038  |                 |
      | 1140        | 1386     | AMBULATORIO    | 037, 038  |                 |
      | 1112        | 1265     | AMBULATORIO    |           | 002, 010        |
      | 1112        | 1799     | AMBULATORIO    |           | 002, 010        |
      | 168         | 1197     | AMBULATORIO    |           | 002, 010        |
      | 1211        | 1623     | AMBULATORIO    |           | 002, 010        |
      | 1211        | 1626     | AMBULATORIO    |           | 002, 010        |
      | 1213        | 1644     | AMBULATORIO    | 037, 038  |                 |
      | 1213        | 1645     | AMBULATORIO    | 037, 038  |                 |
      | 1124        | 1318     | AMBULATORIO    |           | 002, 010        |
      | 1196        | 1536     | AMBULATORIO    |           | 002, 010        |
      | 1126        | 1321     | AMBULATORIO    |           | 002, 010        |
      | 199         | 1237     | AMBULATORIO    |           | 002, 010        |

  @enc002b @smoke @happy-path
  Scenario Outline: RULE 2 TAB 2  Garantia EPS
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
    And contiene el siguiente servicio:
      | order_id   | sede   | ambito   | financiador   | producto   | plan   | beneficio   | codigo_autorizacion   | tipo_encounter   | codigo_prestacion   | importe   | cantidad   | empresa   |
      | <order_id> | <sede> | <ambito> | <financiador> | <producto> | <plan> | <beneficio> | <codigo_autorizacion> | <tipo_encounter> | <codigo_prestacion> | <importe> | <cantidad> | <empresa> |
    And envia la solicitud al endpoint de encounters
    Then el estado de respuesta debe ser 200
    And la respuesta contiene el encounter_id "CASE-NECESARIOS-001"
    And el encounter tiene 1 servicio
    And el encounter tiene 2 documentos necesarios
    And el encounter tiene 0 documentos reemplazables
    And el servicio 1 en la respuesta tiene order_id <order_id>
    And el servicio 1 en la respuesta tiene codigo_prestacion "<codigo_prestacion>"
    And el servicio 1 en la respuesta tiene importe <importe>
    And el servicio 1 tiene 2 documentos necesarios
    And el servicio 1 tiene 0 documentos reemplazables

    Examples:
      | order_id | sede | ambito | financiador | producto | plan | beneficio | codigo_autorizacion | tipo_encounter | codigo_prestacion | importe | cantidad | empresa |
      | 1        | 4    | 1      | 129         | 1000     | 963  |           | AUT-99999           | AMBULATORIO    | MFR00002          | 800     | 1        | 12      |
      | 1        | 4    | 1      | 266         | 1000     | 963  |           | AUT-99999           | AMBULATORIO    | MFR00400          | 800     | 1        | 12      |
      | 1        | 4    | 1      | 4           | 1000     | 963  |           | AUT-99999           | AMBULATORIO    | MFR00002          | 800     | 1        | 12      |

  @enc003 @smoke @happy-path
  Scenario Outline: RULE 3a  Sustento administrativo (critical exclude)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter | empresa | sede |
      | CASE-NECESARIOS-001 | <financiador> | 200           | AMBULATORIO    | 12      | 4    |
    And contiene el siguiente servicio:
      | order_id | empresa | sede | producto   | beneficio    | codigo_autorizacion | codigo_prestacion   | importe | cantidad |
      | 1        | 12      | 4    | <producto> | (cualquiera) | PILOTO              | <codigo_prestacion> | 200    | 1        |
    And envia la solicitud al endpoint de encounters
    Then el estado de respuesta debe ser 200
    And la respuesta contiene el encounter_id "CASE-NECESARIOS-001"
    And el servicio 1 en la respuesta tiene order_id 1
    And el servicio 1 en la respuesta tiene codigo_prestacion "<codigo_prestacion>"
    And el servicio 1 en la respuesta tiene importe 200
    And el encuentro indica como documentos necesario "<documents>"

    Examples:
      | financiador  | producto     | codigo_prestacion | documents | document_groups |
      | (cualquiera) | (cualquiera) | ADM00029          | 1         |                 |
      | (cualquiera) | (cualquiera) | ADM00030          | 1         |                 |
      | (cualquiera) | (cualquiera) | ADM00031          | 1         |                 |
      | 1129         | (cualquiera) | MFR00002          | 001, 011  |                 |
      | 164          | (cualquiera) | MFR00002          | 001, 002  |                 |
      | 164          | (cualquiera) | MFR00400          | 001, 002  |                 |


  @enc003b @smoke @happy-path
  Scenario Outline: RULE 3b  Medicina física y rehabilitación
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
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
      | 1        | 4    | 1      | 999         | 1437     | 963  |           | AUT-12345           | AMBULATORIO    | MFR00010          | 300     | 1        | 12      |

  @enc003c @smoke @happy-path
  Scenario Outline: RULE 3c  Más de 10 prestaciones MFR (encounter scope)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
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
      | 1        | 4    | 1      | 999         | 1437     | 963  |           | AUT-12345           | AMBULATORIO    | MFR00010          | 300     | 1        | 12      |

  @enc005 @smoke @happy-path
  Scenario Outline: RULE 5  Quimioterapia
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
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
      | 1        | 4    | 1      | 999         | 1437     | 963  |           | AUT-12345           | AMBULATORIO    | QMT00100          | 5000    | 1        | 12      |

  @enc007 @smoke @happy-path
  Scenario Outline: RULE 7  Petroperu importe >= 2000
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
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
      | 1        | 4    | 1      | 128         | 1437     | 963  |           | AUT-12345           | AMBULATORIO    | MFR00010          | 2500    | 1        | 12      |

  @enc008 @smoke @happy-path
  Scenario Outline: RULE 8  Auna Salud con carta de garantía (RMN)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
    And contiene el siguiente servicio:
      | order_id   | sede   | ambito   | financiador   | producto   | plan   | beneficio   | codigo_autorizacion   | tipo_encounter   | codigo_prestacion   | importe   | cantidad   | empresa   | estado |
      | <order_id> | <sede> | <ambito> | <financiador> | <producto> | <plan> | <beneficio> | <codigo_autorizacion> | <tipo_encounter> | <codigo_prestacion> | <importe> | <cantidad> | <empresa> | CITADA |
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
      | order_id | sede | ambito | financiador | producto | plan | beneficio | codigo_autorizacion  | tipo_encounter | codigo_prestacion | importe | cantidad | empresa |
      | 1        | 14   | 1      | 12          | 1447     | 963  | 4419      | AUTORIZACION REGULAR | AMBULATORIO    | RMN00010          | 2000    | 1        | 20      |

  @enc010 @smoke @happy-path
  Scenario Outline: RULE 10  Auna Salud no oncológico (encounter scope, not_any_in)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
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
      | 1        | 4    | 1      | 1134        | 1437     | 963  | 9222      | AUT-12345           | AMBULATORIO    | ECO00010          | 400     | 1        | 12      |

  @enc011 @smoke @happy-path
  Scenario Outline: RULE 11  Oncosalud beneficios 9043/9228/9225 (encounter scope, not_any_in)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
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
      | 1        | 4    | 1      | 999         | 1437     | 963  | 9043      | AUT-12345           | AMBULATORIO    | ECO00010          | 300     | 1        | 12      |
      | 1        | 4    | 1      | 999         | 1437     | 963  | 9228      | AUT-12345           | AMBULATORIO    | ECO00010          | 300     | 1        | 12      |
      | 1        | 4    | 1      | 999         | 1437     | 963  | 9225      | AUT-12345           | AMBULATORIO    | ECO00010          | 300     | 1        | 12      |

  @enc012 @smoke @happy-path
  Scenario Outline: RULE 12  Oncosalud Dr. Auna excluye doc 002
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
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
      | 1        | 4    | 1      | 999         | 1551     | 963  | 9043      | AUT-12345           | AMBULATORIO    | ECO00010          | 400     | 1        | 12      |

  @enc013 @smoke @happy-path
  Scenario Outline: RULE 13  Beneficio 4419 excluye doc 002 en RMN
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
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
      | 1        | 4    | 1      | 1134        | 1437     | 963  | 4419      | AUT-12345           | AMBULATORIO    | RMN00260          | 1200    | 1        | 12      |

  @enc014 @smoke @happy-path
  Scenario Outline: RULE 14  Beneficio 4419 excluye doc 002 (RMN rango alto)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
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
      | 1        | 4    | 1      | 1134        | 1437     | 963  | 8888      | AUT-12345           | AMBULATORIO    | RMN01010          | 1200    | 1        | 12      |

  @enc015 @smoke @happy-path
  Scenario Outline: RULE 15  Fondo BCR con umbral de importe (encounter scope) - importe > 500 con códigos APA/TRA
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
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
      | 1        | 4    | 1      | 119         | 1437     | 963  |           | AUT-12345           | AMBULATORIO    | APA00200          | 800     | 1        | 12      |

  @enc015a @smoke @happy-path
  Scenario Outline: RULE 15  Fondo BCR con umbral de importe (encounter scope) - importe <= 500 con códigos MFR
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
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
      | 1        | 4    | 1      | 119         | 1437     | 963  |           | AUT-12345           | AMBULATORIO    | APA00200          | 800     | 1        | 12      |

  @enc015b @smoke @happy-path
  Scenario Outline: RULE 15  Fondo BCR con umbral de importe (encounter scope) - importe <= 500 con códigos TRA de traslado
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa   | sede   |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | <tipo_encounter> | <empresa> | <sede> |
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
      | 1        | 4    | 1      | 119         | 1437     | 963  |           | AUT-12345           | AMBULATORIO    | TRA00880          | 400     | 1        | 12      |
