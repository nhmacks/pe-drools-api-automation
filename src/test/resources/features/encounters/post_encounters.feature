@encounters
Feature: Encounters
  Como consumidor del API
  Quiero poder registrar encounters con sus servicios
  Para procesar la facturacion de prestaciones medicas

  @enc001 @smoke @happy-path @drools
  Scenario Outline: RULE 1  Código de autorización inválido (critical exclude)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador | importe_total | tipo_encounter   | empresa        | sede |
      | CASE-NECESARIOS-001 | 174         | 1500          | <tipo_encounter> | ECOLAB PERU HO | 4    |
    And contiene el siguiente servicio:
      | order_id | empresa        | sede | producto | beneficio | codigo_autorizacion   | codigo_prestacion | importe | cantidad |
      | 1        | ECOLAB PERU HO | 4    | 1437     | 350       | <codigo_autorizacion> | APA00005          | 1500    | 1        |
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
      | encounter_id        | financiador   | importe_total | tipo_encounter | empresa        | sede |
      | CASE-NECESARIOS-001 | <financiador> | 1500          | AMBULATORIO    | ECOLAB PERU HO | 4    |
    And contiene el siguiente servicio:
      | order_id | empresa        | sede | producto   | beneficio | codigo_autorizacion | codigo_prestacion | importe | cantidad |
      | 1        | ECOLAB PERU HO | 4    | <producto> |           | 123                 | ECO00110          | 1500    | 1        |
    And envia la solicitud al endpoint de encounters
    Then el estado de respuesta debe ser 200
    And la respuesta contiene el encounter_id "CASE-NECESARIOS-001"
    And el servicio 1 en la respuesta tiene codigo_prestacion "ECO00110"
    And el servicio 1 en la respuesta tiene importe 1500
    And el encuentro indica como documentos necesario "<documento_necesario>"
    And el encuentro indica como documentos reemplazables "<documento_reemplazable>"
    And el servicio 1 indica documentos necesarios "<documento_necesario>"
    Examples:
      | financiador | producto | documento_necesario | documento_reemplazable |
      | 1174        | 1447     | 002                 |                        |
      | 1171        | 1440     |                     | 002, 010               |
      | 1164        | 1448     | 002                 |                        |
      | 1137        | 1346     | 002                 |                        |
      | 1140        | 1434     | 037, 038            |                        |
      | 1140        | 1386     | 037, 038            |                        |
      | 1112        | 1265     |                     | 002, 010               |
      | 1112        | 1799     |                     | 002, 010               |
      | 168         | 1197     |                     | 002, 010               |
      | 1211        | 1623     |                     | 002, 010               |
      | 1211        | 1626     |                     | 002, 010               |
      | 1213        | 1644     | 037, 038            |                        |
      | 1213        | 1645     | 037, 038            |                        |
      | 1124        | 1318     |                     | 002, 010               |
      | 1196        | 1536     |                     | 002, 010               |
      | 1126        | 1321     |                     | 002, 010               |
      | 199         | 1237     |                     | 002, 010               |
      | 1232        | 1703     |                     | 011, 010, 009, 012     |
      #| 1134        | 1577     |                     | 011, 010, 009, 012     |
      #| 186         | 1219     |                     | 002, 010               |
      #| 174         | 1206     | 2                   |                        |
      #| 175         | 1207     | 2                   |                        |
      #| 125         | 184      | 2                   |                        |
      #| 137         | 1118     |                     | 002, 010               |
      #| 1227        | 1678     | 10                  |                        |
      #| 1217        | 1671     | 10                  |                        |
      #| 1132        | 1331     | 2                   |                        |
      #| 1141        | 1392     |                     | 002, 010               |
      #| 144         | 1131     |                     | 002, 010               |
      #| 176         | 1208     | 2                   |                        |
      #| 1222        | 1687     |                     | 002, 010               |
      #| 182         | 1527     |                     | 002, 010               |
      #| 1144        | 1397     |                     | 002, 010               |
      #| 1152        | 1404     |                     | 002, 010               |
      #| 1219        | 1684     |                     | 002, 010               |
      #| 1163        | 1426     | 037, 038            |                        |
      #| 1218        | 1673     |                     | 002, 010               |
      #| 192         | (sin     | 2                   |                        |
      #| 1210        | 1611     |                     | 002, 010               |
      #| 1154        | 1412     |                     | 002, 010               |
      #| 112         | 1625     |                     | 002, 010               |
      #| 1129        | 1328     | 2                   |                        |
      #| 1109        | 1300     | 2                   |                        |
      #| 1200        | 1563     | 2                   |                        |
      #| 1108        | 1252     | 2                   |                        |
      #| 177         | 1209     | 2                   |                        |
      #| 1125        | 1319     | 2                   |                        |
      #| 1123        | 1317     | 2                   |                        |
      #| 1127        | 1320     | 39                  |                        |
      #| 1224        | 1685     | 37                  |                        |
      #| 119         | 15385    |                     | 011, 010               |
      #| 117         | 174      | 2                   |                        |
      #| 1106        | 1247     | 2                   |                        |
      #| 153         | 1147     | 2                   |                        |
      #| 1102        | 1243     | 2                   |                        |
      #| 1207        | 1594     | 2                   |                        |
      #| 171         | 1200     | 2                   |                        |
      #| 1203        | 1586     | 37                  |                        |
      #| 1142        | 1293     | 2                   |                        |
      #| 1151        | 1405     |                     | 002, 010               |
      #| 183         | 1215     |                     | 002, 010               |
      #| 1247        | 1746     | 2                   |                        |
      #| 184         | 1217     | 2                   |                        |
      #| 19          | 1437     | 002, 037            |                        |
      #| 185         | 1218     | 2                   |                        |
      #| 133         | 1618     | 002, 040            |                        |
      #| 1177        | 1459     | 037, 038            |                        |
      #| 1111        | 1257     | 2                   |                        |
      #| 1100        | 1241     | 2                   |                        |
      #| 130         | 1103     | 006, 002            | 007, 005               |
      #| 130         | 1534     | 2                   |                        |
      #| 1175        | 1452     | 037, 038            |                        |
      #| 1168        | 1432     |                     | 002, 010               |
      #| 173         | 1204     |                     | 011, 010, 009          |
      #| 14          | 1702     | 41                  | 011, 010, 009          |
      #| 14          | 127      |                     | 011, 010, 009          |
      #| 14          | 126      | 006, 002            | 007, 005               |
      #| 178         | 1210     | 2                   |                        |
      #| 1226        | 1677     | 2                   |                        |
      #| 187         | (sin     |                     | 002, 010               |
      #| 18          | 1726     |                     | 011, 010, 009          |
      #| 18          | 145,     | 3                   | 011, 010, 009          |
      #| 110         | 143,     |                     | 011, 010, 009          |
      #| 110         | 124,     | 006, 002            | 007, 005               |
      #| 1146        | 1399     |                     | 002, 010               |
      #| 1192        | 1500     |                     | 010, 002               |
      #| 172         | 1203     | 2                   |                        |
      #| 1158        | 1416     |                     | 002, 010               |
      #| 122         | 1571     |                     | 011, 010, 009          |
      #| 1104        | 1245     | 2                   |                        |
      #| 1133        | 1335     | 2                   |                        |
      #| 1130        | 1329     | 2                   |                        |
      #| 157         | 1160     |                     | 011, 010, 009          |
      #| 179         | (sin     | 2                   |                        |
      #| 1161        | 1419     | 006, 002            | 007, 005               |
      #| 1155        | 1413     |                     | 002, 010               |
      #| 1165        | 1429     |                     | 002, 010               |
      #| 1118        | 1291     | 2                   |                        |
      #| 197         | 1232     | 2                   |                        |
      #| 12          | 1352     |                     | 011, 012               |
      #| 12          | 1551     |                     | 011, 010, 009          |
      #| 12          | 1515     |                     | 011, 010, 009, 012     |
      #| 141         | 1520     | 2                   |                        |
      #| 196         | 1231     | 2                   |                        |
      #| 16          | 1175     |                     | 011, 010, 009          |
      #| 16          | 125,     | 3                   | 011, 010, 009          |
      #| 17          | 1176     |                     | 011, 010, 009          |
      #| 17          | 123      | 006, 002            | 007, 005               |
      #| 1105        | 1246     | 2                   |                        |
      #| 1184        | 1478     | 2                   |                        |
      #| 1244        | 1734     | 37                  |                        |
      #| 135         | 1111     | 2                   |                        |
      #| 128         | 1572     |                     | 011, 010, 009          |
      #| 180         | 1212     | 2                   |                        |
      #| 1159        | 1436     | 37                  |                        |
      #| 1180        | 1466     | 37                  |                        |
      #| 166         | 1178     | 2                   |                        |
      #| 143         | 1128     |                     | 011, 010, 009, 002     |
      #| 143         | 1533     |                     | 002, 010               |
      #| 143         | 1391     | 006, 002            | 007, 005               |
      #| 1239        | 1713     | 006, 002            | 007, 005               |
      #| 1128        | 1324     | 2                   |                        |
      #| 181         | 1213     | 2                   |                        |
      #| 1237        | 1711     | 37                  |                        |
      #| 1238        | 1712     | 2                   |                        |
      #| 13          | 15,      |                     | 011, 010, 009          |
      #| 13          | 128      | 3                   |                        |
      #| 15          | 1659     |                     | 011, 010, 009          |
      #| 15          | 198      | 021, 006, 002       | 007, 005               |
      #| 139         | 1411     | 2                   |                        |
      #| 111         | 144      |                     | 011, 010, 009          |
      #| 111         | 146      | 3                   | 011, 010, 009          |
      #| 164         | 1573     |                     | 011, 010, 009          |
      #| 127         | 1395     | 2                   |                        |
      #| 114         | 155,     | 2                   |                        |
      #| 124         | 192,     | 2                   |                        |
      #| 1107        | 1249     | 2                   | 011, 010, 009          |
      #| 1173        | 1443     | 2                   |                        |
      #| 1249        | 1752     |                     | 011, 010, 009          |
      #| 1122        | 1665     |                     | 017, 002               |
      #| 1122        | 1451     |                     | 011, 010, 009          |
      #| 1122        | 1312     |                     | 011, 017, 010, 009     |
      #| 1116        | 1396     | 2                   |                        |
      #| 160         | 1168     | 2                   |                        |
      #| 188         | 1221     | 2                   |                        |
      #| 1149        | 1402     | 2                   |                        |
      #| 1153        | 1409     | 37                  |                        |
      ##| 1252        | (sin     | 002, 010            |                        |
      #| 1197        | 1537     | 037, 038            |                        |
      #| 1117        | 1548     | 2                   |                        |
      #| 170         | 1199     | 2                   |                        |
      #| 1246        | 1743     | 2                   |                        |
      #| 194         | 1230     | 2                   |                        |
      #| 140         | 1742     | 2                   |                        |
      #| 1215        | 1656     | 2                   |                        |
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
    And el servicio 1 en la respuesta tiene codigo_prestacion "<codigo_prestacion>"
    And el servicio 1 en la respuesta tiene importe 200
    And el encuentro indica como documentos necesario "<documento_necesario>"
    And el encuentro indica como documentos reemplazables "<documento_reemplazable>"
    And el servicio 1 indica documentos necesarios "<documento_necesario>"

    Examples:
      | financiador  | nom_financiador     | producto     | codigo_prestacion | documento_necesario | documento_reemplazable |
      | (cualquiera) |                     | (cualquiera) | ADM00029          |                     |                        |
      | (cualquiera) |                     | (cualquiera) | ADM00030          |                     |                        |
      | (cualquiera) |                     | (cualquiera) | ADM00031          |                     |                        |
      | (cualquiera) |                     | (cualquiera) | MFR00002          |                     |                        |
      | (cualquiera) |                     | (cualquiera) | MFR00400          |                     |                        |
      | (cualquiera) |                     | (cualquiera) | FAC01345          |                     |                        |
      | (cualquiera) |                     | (cualquiera) | FAC01346          |                     |                        |
      | 1129         | Corpac              | (cualquiera) | MFR00002          | 001, 002, 011       |                        |
      | 164          | Sedapal             | (cualquiera) | MFR00002          | 001, 002            |                        |
      | 164          | Sedapal             | (cualquiera) | MFR00400          | 001, 002            | 009, 010, 011          |
      | 1249         | Sima                | (cualquiera) | FAC01345          | 001, 002            |                        |
      | 1266         | Grandia             | (cualquiera) | FAC01346          | 001, 002, 003       | 002, 010               |
      | 1266         | Grandia             | (cualquiera) | MFR00108          | 001, 002,003        | 002, 010               |
      | 14           | La Positiva Seguros | (cualquiera) | MFR00002          | 001                 |                        |
      | 173          | EPS                 | (cualquiera) | MFR00400          | 001                 |                        |
    #Observacion: Si se indica un beneficio en el servicio, este no entra en la regla, si el beneficio es null, si entra en la regla

  @enc005 @smoke @happy-path @drools
  Scenario Outline: RULE 5  Quimioterapia
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter | empresa        | sede |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | AMBULATORIO    | ECOLAB PERU HO | 4    |
    And contiene el siguiente servicio:
      | order_id | empresa        | sede | producto   | beneficio | codigo_autorizacion | codigo_prestacion   | importe   | cantidad |
      | 1        | ECOLAB PERU HO | 4    | <producto> |           | 90000122120         | <codigo_prestacion> | <importe> | 1        |
    And envia la solicitud al endpoint de encounters
    Then el estado de respuesta debe ser 200
    And la respuesta contiene el encounter_id "CASE-NECESARIOS-001"
    And el servicio 1 en la respuesta tiene codigo_prestacion "<codigo_prestacion>"
    And el servicio 1 en la respuesta tiene importe <importe>
    And el encuentro indica como documentos necesario "<documento_necesario>"
    And el encuentro indica como documentos reemplazables "<documento_reemplazable>"
    And el servicio 1 indica documentos necesarios "<documento_necesario>"

    Examples:
      | order_id | financiador  | cod_financiador              | producto     | codigo_prestacion | importe | documento_necesario | documento_reemplazable           |
      | 1        | (cualquiera) |                              | (cualquiera) | QMT00010          | 1       | 002, 040            |                                  |
      | 1        | (cualquiera) |                              | (cualquiera) | QMT01590          | 500     | 002                 |                                  |
      | 1        | (cualquiera) |                              | (cualquiera) | TRA00670          | 5000    | 002                 | 002, 010                         |
      | 1        | (cualquiera) |                              | (cualquiera) | PAQ00532          | 1       | 002                 |                                  |
      | 1        | (cualquiera) |                              | (cualquiera) | PAQ00533          | 5000    | 002                 |                                  |
      | 1        | != 12        | cualquiera excepto Oncosalud | (cualquiera) | FAC00075          | 5000    |                     | [011, 010, 009, 012], [002, 012] |
      | 1        | != 12        | cualquiera excepto Oncosalud | (cualquiera) | PRQ00196          | 5000    | 002, 006            | 005, 007                         |
      | 1        | != 12        | cualquiera excepto Oncosalud | (cualquiera) | PRQ02905          | 5000    | 002                 | 002, 010                         |
      | 1        | != 12        | cualquiera excepto Oncosalud | (cualquiera) | QRI00860          | 5000    | 002                 |                                  |
      | 1        | != 12        | cualquiera excepto Oncosalud | (cualquiera) | RIN00860          | 5000    | 002                 | 002, 010                         |
      | 1        | != 12        | cualquiera excepto Oncosalud | (cualquiera) | TRA00540          | 5000    | 002                 | 009, 010, 011, 012               |
      | 1        | != 12        | cualquiera excepto Oncosalud | (cualquiera) | TRA00541          | 5000    | 002                 | 002, 010                         |
      | 1        | != 12        | cualquiera excepto Oncosalud | (cualquiera) | TRA00542          | 5000    | 002                 |                                  |
      | 1        | != 12        | cualquiera excepto Oncosalud | (cualquiera) | TRA00543          | 5000    | 002                 | 009, 010, 011, 012               |
      | 1        | != 12        | cualquiera excepto Oncosalud | (cualquiera) | TRA00544          | 5000    | 002                 | 009, 010, 011, 012               |
      | 1        | != 12        | cualquiera excepto Oncosalud | (cualquiera) | TRA00901          | 5000    | 002                 |                                  |
      | 1        | != 12        | cualquiera excepto Oncosalud | (cualquiera) | TRA05100          | 5000    | 002                 |                                  |

  @enc007 @smoke @happy-path @drools
  Scenario Outline: RULE 7  Petroperu importe >= 2000
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter | empresa        | sede |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | AMBULATORIO    | ECOLAB PERU HO | 4    |
    And contiene el siguiente servicio:
      | order_id | empresa        | sede | producto   | beneficio | codigo_autorizacion | codigo_prestacion   | importe   | cantidad |
      | 1        | ECOLAB PERU HO | 4    | <producto> |           | 90000122120         | <codigo_prestacion> | <importe> | 1        |
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
      | order_id | financiador | cod_financiador | producto     | codigo_prestacion | importe | documento_necesario | documento_reemplazable |
      | 1        | 128         | Petroperu       | (cualquiera) | MFR00002          | 2000    | 002, 001            | 009, 010, 011          |
      | 1        | 128         | Petroperu       | (cualquiera) | MFR00400          | 2001    | 002, 001            | 009, 010, 011          |
      | 1        | 128         | Petroperu       | (cualquiera) | TRA00880          | 2001    | 011                 | 009, 010, 011          |
      | 1        | 128         | Petroperu       | (cualquiera) | TRA00890          | 2001    | 011                 | 009, 010, 011          |
      | 1        | 128         | Petroperu       | (cualquiera) | TRA00900          | 2001    | 011                 | 009, 010, 011          |
      | 1        | 128         | Petroperu       | (cualquiera) | TRA02200          | 2001    | 011                 | 009, 010, 011          |

  @enc009 @smoke @happy-path @drools
  Scenario Outline: RULE 8  Auna Salud con carta de garantía (RMN)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter | empresa        | sede |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | AMBULATORIO    | ECOLAB PERU HO | 4    |
    And contiene el siguiente servicio:
      | order_id | empresa        | sede | producto   | beneficio | codigo_autorizacion | codigo_prestacion   | importe   | cantidad |
      | 1        | ECOLAB PERU HO | 4    | <producto> |           | 90000122120         | <codigo_prestacion> | <importe> | 1        |
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
      | order_id | financiador | cod_financiador | producto     | codigo_prestacion | importe | documento_necesario | documento_reemplazable |
      | 1        | 1134        | Petroperu       | (cualquiera) | RMN00260          | 2000    | 002                 |                        |
      | 1        | 1134        | Petroperu       | (cualquiera) | RMN00270          | 2001    | 002                 |                        |
      | 1        | 1134        | Petroperu       | (cualquiera) | RMN00610          | 2001    | 002                 |                        |
      | 1        | 1134        | Petroperu       | (cualquiera) | RMN00870          | 2001    | 002                 |                        |
      | 1        | 1134        | Petroperu       | (cualquiera) | RMN01230          | 2001    | 002                 |                        |
      | 1        | 1134        | Petroperu       | (cualquiera) | RMN00010          | 2001    |                     |                        |
      | 1        | 1134        | Petroperu       | (cualquiera) | RMN00600          | 2001    |                     |                        |
      | 1        | 1134        | Petroperu       | (cualquiera) | RMN00810          | 2001    |                     |                        |
      | 1        | 1134        | Petroperu       | (cualquiera) | RMN01220          | 2001    |                     |                        |

  @enc010 @smoke @happy-path @drools
  Scenario Outline: RULE 10  Auna Salud no oncológico (encounter scope, not_any_in)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter | empresa   | sede |
      | CASE-NECESARIOS-001 | <financiador> | <importe>     | AMBULATORIO    | <empresa> | 4    |
    And contiene el siguiente servicio:
      | order_id | empresa        | sede   | producto   | beneficio | codigo_autorizacion | codigo_prestacion   | importe   | cantidad |
      | 1        | ECOLAB PERU HO | <sede> | <producto> |           | 90000122120         | <codigo_prestacion> | <importe> | 1        |
    And envia la solicitud al endpoint de encounters
    Then el estado de respuesta debe ser 200
    And la respuesta contiene el encounter_id "CASE-NECESARIOS-001"
    And el encounter tiene 1 servicio
    And el servicio 1 en la respuesta tiene order_id <order_id>
    And el servicio 1 en la respuesta tiene codigo_prestacion "<codigo_prestacion>"
    And el servicio 1 en la respuesta tiene importe <importe>
    And el encuentro indica como documentos necesario "<documento_necesario>"
    And el encuentro indica como documentos reemplazables "<documento_reemplazable>"
    And el servicio 1 indica documentos necesarios "<documento_necesario>"

    Examples:
      | order_id | financiador | cod_financiador | empresa     | sede | producto     | codigo_prestacion | importe | documento_necesario | documento_reemplazable |
      | 1        | 12          | Oncosalud       | CERRO VERDE | 1    | (cualquiera) | RMN00010          | 0       | 002,012             |                        |
      | 1        | 12          | Oncosalud       | CERRO VERDE | 1    | (cualquiera) | TRA04990          | 99999   | 002, 012            |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 1    | (cualquiera) | RDT00786          | 700     | 002                 |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 3    | (cualquiera) | RDT00786          | 700     | 002                 |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 4    | (cualquiera) | RDT00786          | 700     | 002                 |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 10   | (cualquiera) | RDT00786          | 700     | 002                 |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 13   | (cualquiera) | RDT00786          | 700     | 002                 |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 15   | (cualquiera) | RDT00786          | 700     | 002                 |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 17   | (cualquiera) | RDT00786          | 99999   | 002                 |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 1    | (cualquiera) | ECO00770          | 700     | 002                 |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 3    | (cualquiera) | MNU00394          | 700     | 002                 |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 4    | (cualquiera) | ADM00187          | 700     | 002                 |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 10   | (cualquiera) | MIC00109          | 700     | 002                 |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 13   | (cualquiera) | PAQ02271          | 700     | 002                 |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 15   | (cualquiera) | ENF00810          | 700     | 002                 |                        |
      | 1        | 1122        | Fesunat         | Cualquiera  | 17   | (cualquiera) | PAQ02246          | 99999   | 002                 |                        |

  @enc011 @smoke @happy-path
  Scenario Outline: RULE 11  Oncosalud beneficios 9043/9228/9225 (encounter scope, not_any_in)
    When el "cliente" envia un encounter con los siguientes datos:
      | encounter_id        | financiador   | importe_total | tipo_encounter | empresa        | sede |
      | CASE-NECESARIOS-001 | <financiador> | 200           | AMBULATORIO    | ECOLAB PERU HO | 1    |
    And contiene el siguiente servicio:
      | order_id | empresa        | sede | producto   | beneficio   | codigo_autorizacion | codigo_prestacion   | importe | cantidad |
      | 1        | ECOLAB PERU HO | 1    | <producto> | <beneficio> | 90000122120         | <codigo_prestacion> | 200     | 1        |
    And envia la solicitud al endpoint de encounters
    Then el estado de respuesta debe ser 200
    And la respuesta contiene el encounter_id "CASE-NECESARIOS-001"
    And el servicio 1 en la respuesta tiene codigo_prestacion "<codigo_prestacion>"
    And el servicio 1 en la respuesta tiene importe 200
    And el encuentro indica como documentos necesario "<documento_necesario>"
    And el encuentro indica como documentos reemplazables "<documento_reemplazable>"
    And el servicio 1 indica documentos necesarios "<documento_necesario>"

    Examples:
      | financiador | producto     | beneficio | codigo_prestacion | documento_necesario | documento_reemplazable |
      | 1134        | (cualquiera) |           |                   |                     |                        |
      | 1134        | (cualquiera) | 9222      | ADM00000          |                     |                        |
      | 1134        | (cualquiera) | 9402      | ADM00000          |                     |                        |
      | 1134        | (cualquiera) | 9225      | ADM00000          |                     |                        |
      | 1232        | (cualquiera) |           |                   |                     |                        |
      | 1232        | (cualquiera) | 9222      | ADM00000          |                     |                        |
      | 1232        | (cualquiera) | 9402      | ADM00000          |                     |                        |
      | 1232        | (cualquiera) | 9225      | ADM00000          |                     |                        |

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
      | order_id | sede | ambito | financiador | producto | plan | beneficio | codigo_autorizacion | tipo_encounter | codigo_prestacion | importe | cantidad | empresa        |
      | 1        | 4    | 1      | 999         | 1551     | 963  | 9043      | AUT-12345           | AMBULATORIO    | ECO00010          | 400     | 1        | ECOLAB PERU HO |

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
      | order_id | sede | ambito | financiador | producto | plan | beneficio | codigo_autorizacion | tipo_encounter | codigo_prestacion | importe | cantidad | empresa        |
      | 1        | 4    | 1      | 1134        | 1437     | 963  | 4419      | AUT-12345           | AMBULATORIO    | RMN00260          | 1200    | 1        | ECOLAB PERU HO |

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
      | order_id | sede | ambito | financiador | producto | plan | beneficio | codigo_autorizacion | tipo_encounter | codigo_prestacion | importe | cantidad | empresa        |
      | 1        | 4    | 1      | 1134        | 1437     | 963  | 8888      | AUT-12345           | AMBULATORIO    | RMN01010          | 1200    | 1        | ECOLAB PERU HO |

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
      | order_id | sede | ambito | financiador | producto | plan | beneficio | codigo_autorizacion | tipo_encounter | codigo_prestacion | importe | cantidad | empresa        |
      | 1        | 4    | 1      | 119         | 1437     | 963  |           | AUT-12345           | AMBULATORIO    | APA00200          | 800     | 1        | ECOLAB PERU HO |

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
      | order_id | sede | ambito | financiador | producto | plan | beneficio | codigo_autorizacion | tipo_encounter | codigo_prestacion | importe | cantidad | empresa        |
      | 1        | 4    | 1      | 119         | 1437     | 963  |           | AUT-12345           | AMBULATORIO    | APA00200          | 800     | 1        | ECOLAB PERU HO |

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
      | order_id | sede | ambito | financiador | producto | plan | beneficio | codigo_autorizacion | tipo_encounter | codigo_prestacion | importe | cantidad | empresa        |
      | 1        | 4    | 1      | 119         | 1437     | 963  |           | AUT-12345           | AMBULATORIO    | TRA00880          | 400     | 1        | ECOLAB PERU HO |
