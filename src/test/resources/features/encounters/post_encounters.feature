@encounters
Feature: Encounters
  Como consumidor del API
  Quiero poder registrar encounters con sus servicios
  Para procesar la facturacion de prestaciones medicas

  @enc001 @smoke @happy-path @drools
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


  @enc002 @smoke @happy-path @drools
  Scenario Outline: RULE 2  Matriz financiador (Hipermercados Tottus)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter   | empresa | sede |
      | CASE-NECESARIOS-001 | <financiador> | 1500          | <tipo_encounter> | 12      | 4    |
    And contiene el siguiente servicio:
      | order_id | empresa | sede | producto   | beneficio | codigo_autorizacion | codigo_prestacion | importe | cantidad |
      | 1        | 12      | 4    | <producto> |           | 123                 | ECO00110          | 1500    | 1        |
    And envia la solicitud al endpoint de encounters
    Then el estado de respuesta debe ser 200
    And la respuesta contiene el encounter_id "CASE-NECESARIOS-001"
    And el servicio 1 en la respuesta tiene codigo_prestacion "ECO00110"
    And el servicio 1 en la respuesta tiene importe 1500
    And el encuentro indica como documentos necesario "<documento_necesario>"
    And el encuentro indica como documentos reemplazables "<documento_reemplazable>"
    And el servicio 1 indica documentos necesarios "<documento_necesario>"
    Examples:
      | financiador | producto | tipo_encounter | documento_necesario | documento_reemplazable |
      | 1174        | 1447     | AMBULATORIO    | 002                 |                        |
      | 1171        | 1440     | AMBULATORIO    |                     | 002, 010               |
      | 1164        | 1448     | AMBULATORIO    | 002                 |                        |
      | 1137        | 1346     | AMBULATORIO    | 002                 |                        |
      | 1140        | 1434     | AMBULATORIO    | 037, 038            |                        |
      | 1140        | 1386     | AMBULATORIO    | 037, 038            |                        |
      | 1112        | 1265     | AMBULATORIO    |                     | 002, 010               |
      | 1112        | 1799     | AMBULATORIO    |                     | 002, 010               |
      | 168         | 1197     | AMBULATORIO    |                     | 002, 010               |
      | 1211        | 1623     | AMBULATORIO    |                     | 002, 010               |
      | 1211        | 1626     | AMBULATORIO    |                     | 002, 010               |
      | 1213        | 1644     | AMBULATORIO    | 037, 038            |                        |
      | 1213        | 1645     | AMBULATORIO    | 037, 038            |                        |
      | 1124        | 1318     | AMBULATORIO    |                     | 002, 010               |
      | 1196        | 1536     | AMBULATORIO    |                     | 002, 010               |
      | 1126        | 1321     | AMBULATORIO    |                     | 002, 010               |
      | 199         | 1237     | AMBULATORIO    |                     | 002, 010               |
#Observacion: si se indica un beneficio en el servicio, este no entra en la regla, si el beneficio es null, si entra en la regla

  @enc003 @smoke @happy-path @drools
  Scenario Outline: RULE 3a  Sustento administrativo (critical exclude)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter | empresa        | sede |
      | CASE-NECESARIOS-001 | <financiador> | 200           | AMBULATORIO    | ECOLAB PERU HO | 1    |
    And contiene el siguiente servicio:
      | order_id | empresa        | sede | producto   | beneficio    | codigo_autorizacion | codigo_prestacion   | importe | cantidad |
      | 1        | ECOLAB PERU HO | 1    | <producto> | (cualquiera) | 90000122120         | <codigo_prestacion> | 200     | 1        |
    And envia la solicitud al endpoint de encounters
    Then el estado de respuesta debe ser 200
    And la respuesta contiene el encounter_id "CASE-NECESARIOS-001"
    And el servicio 1 en la respuesta tiene order_id 1
    And el servicio 1 en la respuesta tiene codigo_prestacion "<codigo_prestacion>"
    And el servicio 1 en la respuesta tiene importe 200
    And el encuentro indica como documentos necesario "<documento_necesario>"
    And el encuentro indica como documentos reemplazables "<documento_reemplazable>"
    And el servicio 1 indica documentos necesarios "<documento_necesario>"

    Examples:
      | financiador  | producto     | codigo_prestacion | documento_necesario | documento_reemplazable |
      | (cualquiera) | (cualquiera) | ADM00029          |                     |                        |
      | (cualquiera) | (cualquiera) | ADM00030          |                     |                        |
      | (cualquiera) | (cualquiera) | ADM00031          |                     |                        |
      | 1129         | (cualquiera) | MFR00002          | 001, 002, 011       |                        |
      | 164          | (cualquiera) | MFR00002          | 001, 002            | 009, 010, 011          |
      | 164          | (cualquiera) | MFR00400          | 001, 002            | 009, 010, 011          |
      | 1249         | (cualquiera) | FAC01345          | 001, 002            |                        |
      | 1266         | (cualquiera) | FAC01346          | 001, 002, 003       | 002, 010               |
      | 1266         | (cualquiera) | MFR00108          | 001, 002,003        | 002, 010               |
      | 14           | (cualquiera) | MFR00002          | 001                 |                        |
      | 173          | (cualquiera) | MFR00400          | 001                 |                        |
    #Observacion: Si se indica un beneficio en el servicio, este no entra en la regla, si el beneficio es null, si entra en la regla

  @enc005 @smoke @happy-path @drools
  Scenario Outline: RULE 5  Quimioterapia
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador  | importe_total | tipo_encounter | empresa        | sede |
      | CASE-NECESARIOS-001 | (cualquiera) | <importe>     | AMBULATORIO    | ECOLAB PERU HO | 4    |
    And contiene el siguiente servicio:
      | order_id | empresa        | sede | producto     | beneficio | codigo_autorizacion | codigo_prestacion   | importe   | cantidad |
      | 1        | ECOLAB PERU HO | 4    | (cualquiera) |           | 90000122120         | <codigo_prestacion> | <importe> | 1        |
    And envia la solicitud al endpoint de encounters
    Then el estado de respuesta debe ser 200
    And la respuesta contiene el encounter_id "CASE-NECESARIOS-001"
    And el encounter tiene 1 servicio
    And el encounter tiene 0 documentos necesarios
    And el encounter tiene 0 documentos reemplazables
    And el servicio 1 en la respuesta tiene order_id <order_id>
    And el servicio 1 en la respuesta tiene codigo_prestacion "<codigo_prestacion>"
    And el servicio 1 en la respuesta tiene importe <importe>
    And el encuentro indica como documentos necesario "<documento_necesario>"
    And el encuentro indica como documentos reemplazables "<documento_reemplazable>"
    And el servicio 1 indica documentos necesarios "<documento_necesario>"

    Examples:
      | order_id | codigo_prestacion | importe | documento_necesario | documento_reemplazable |
      | 1        | TRA00670          | 1       | 002                 | 011, 010, 009          |
      #| 1        | QMT00100          | 500     | 002                 |                        |
      #| 1        | PAQ00532          | 5000    | 002                 |                        |

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
