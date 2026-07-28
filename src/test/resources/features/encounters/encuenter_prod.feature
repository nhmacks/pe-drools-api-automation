@debug-encounters
Feature: Consultar detalles de encuentros en producción
  Como QA tester
  Quiero poder consultar los detalles de encuentros desde el endpoint de debug
  Para visualizar las tablas de datos de manera organizada en HTML

  @debug001 @consulta-encuentro
  Scenario Outline: Consultar detalles de encuentro y generar reporte HTML
    Given se limpian los reportes anteriores si es el primer encuentro
    And el usuario tiene acceso al endpoint de debug
    When consulta el encuentro con visit_occurrence_id "<visit_occurrence_id>"
    Then el estado de respuesta debe ser 200
    And se genera un reporte HTML

    Examples:
      | visit_occurrence_id |
      | 128800388           |
      | 128837686           |
      | 128863618           |
      | 128867262           |
      | 128873400           |
      | 128882281           |
      | 128898650           |
      | 128923072           |
      | 128923546           |
      | 128956597           |
      | 128964309           |

