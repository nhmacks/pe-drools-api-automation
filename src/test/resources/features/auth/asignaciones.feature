Feature: Asignaciones

  Scenario: Registrar evento de taggeo al ingresar a la bandeja de asignaciones
    Given El usuario ingresa a la bandeja de asignaciones
    Then se registra un evento de taggeo en amplitud con el nombre "PAGINA_VER_ASIGNACIONES"
    #nombre, usuario, correo, fecha, hora, rol
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And el rol del usuario


  Scenario Outline: Registrar evento de taggeo al seleccionar el boton Buscar en la bandeja de asignaciones
    Given El usuario ingresa a la bandeja de asignaciones
    #Resp. Facturacion/Asignaciones
    And selecciona una fecha de inicio en el filtro
    And selecciona una fecha de fin en el filtro
    And selecciona "<filtro>" tipo de garante en el filtro
    When El usuario selecciona el boton Buscar
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_BUSCAR"
    #nombre, usuario, correo, fecha, hora, rol, (filtros) fecha inicio, fecha fin y tipo de garante, cantidad de registros, cantidad de encuentros y monto
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And registra fecha de inicio del filtro
    And registra fecha de fin del filtro
    And registra tipo de garante del filtro "<filtro>"
    And registra cantidad de registros encontrados
    And registra cantidad de encuentros encontrados
    And registra monto total encontrado
    And el rol del usuario

    Examples:
      | filtro                     |
      | un tipo de garante         |
      | 5 tipos de garante         |
      | todos los tipos de garante |

  Scenario Outline: Registrar evento de taggeo al seleccionar el boton "Limpiar filtros" en la bandeja de asignaciones
    Given El usuario ingresa a la bandeja de asignaciones
    And selecciona una fecha de inicio en el filtro
    And selecciona una fecha de fin en el filtro
    And seleccionar "<filtro>" tipo de garante en el filtro
    And selecionar el boton Buscar
    When El usuario selecciona el boton "Limpiar"
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_LIMPIAR"
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And registra fecha de inicio del filtro
    And registra fecha de fin del filtro
    And registra tipo de garante del filtro "<filtro>"
    And registra cantidad de registros encontrados
    And registra cantidad de encuentros encontrados
    And registra monto total encontrado
    And el rol del usuario

    Examples:
      | filtro                     |
      | sin tipo de garante        |
      | un tipo de garante         |
      | 5 tipos de garante         |
      | todos los tipos de garante |


  Scenario Outline: Registrar evento de taggeo al seleccionar el boton asignar en la bandeja de asignaciones
    Given El usuario ingresa a la bandeja de asignaciones
    And selecciona una fecha de inicio en el filtro
    And selecciona una fecha de fin en el filtro
    And seleccionar un tipo de garante en el filtro
    And seleciona el boton Buscar
    And selecciona "<cantidad_registros>" registros de la tabla de resultados
    When El usuario selecciona el boton "Asignar"
    # nombre, usuario, correo, fecha, hora, rol, (filtros) fecha inicio, fecha fin y tipo de garante,
    # cantidad de registros selecionados, cantidad de encuentros y monto
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_ASIGNAR"
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And registra fecha de inicio del filtro
    And registra fecha de fin del filtro
    And registra tipo de garante del filtro
    And registra cantidad de registros encontrados
    And registra cantidad de encuentros encontrados
    And registra monto total encontrado
    And el rol del usuario
    Examples:
      | cantidad_registros |
      | 1                  |
      | 10                 |
      | 20                 |

