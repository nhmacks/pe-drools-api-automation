Feature: Lista de encuentros
  Como responsable de facturación
  Quiero poder ver la lista de encuentros
  Para poder gestionar los encuentros de manera eficiente


  Scenario: Registrar evento de taggeo en amplitud al ingresar a lista de encuentros
    Given que el responsable de facturación ingresa a la lista de encuentros
    Then se registra un evento de taggeo en amplitud con el nombre "PAGINA_VER_LISTA_ENCUENTROS"
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And el rol del usuario

  @tag03
  Scenario Outline: Registrar evento de taggeo en amplitud al realizar filtro por nombre
    Given que el responsable de facturación ingresa a la lista de encuentros
    When realiza un filtro por <filtro>
    Then se registra un evento de taggeo en amplitud con el nombre "ENTRADA_BUSQUEDA"
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And el rol del usuario


    Examples:
      | filtro           |
      | nombre           |
      | apellido         |
      | nro de encuentro |

  @tag04
  Scenario Outline: Registrar evento de taggeo en amplitud al seleccionar el boton "Asignar"
    Given que el responsable de facturación ingresa a la lista de encuentros
    And selecciona "<cantidad_encuentros>" encuentro
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_ASIGNAR"
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And el rol del usuario
    And se registra la cantidad de encuentros seleccionados

    Examples:
      | cantidad_encuentros |
      | 1 encuentro         |
      | 50 encuentros       |
      | 100 encuentros      |

  @tag05
  Scenario: Registrar evento de taggeo en amplitud al seleccionar el boton "asignar" en el modal
    Given que el responsable de facturación ingresa a la lista de encuentros
    And selecciona "<cantidad_encuentros>" encuentro
    And selecciona el botón "Asignar"
    And selecciona un ejecutivo a quien asignar el encuentro
    When selecciona el botón "Asignar" en el modal
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_ASIGNAR_MODAL"
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And el rol del usuario
    And se registra el ejecutivo seleccionado para asignar el encuentro
    And se registra la cantidad de encuentros seleccionados

    Examples:
      | cantidad_encuentros |
      | 1 encuentro         |
      | 50 encuentros       |
      | 100 encuentros      |

  @tag06
  Scenario Outline: Registrar evento de taggeo en amplitud al cancelar la asignación en el modal luego de seleccionar un ejecutivo
    Given que el responsable de facturación ingresa a la lista de encuentros
    And selecciona "<cantidad_encuentros>" encuentro
    And selecciona el botón "Asignar"
    And selecciona un ejecutivo a quien asignar el encuentro
    When selecciona el botón "Cancelar" en el modal
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_CANCELAR_MODAL"
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And el rol del usuario
    And se registra el ejecutivo seleccionado para asignar el encuentro
    And se registra la cantidad de encuentros seleccionados
    Examples:
      | cantidad_encuentros |
      | 1 encuentro         |
      | 50 encuentros       |
      | 100 encuentros      |

  @tag06_2
  Scenario Outline: Registrar evento de taggeo en amplitud al cancelar la asignación en el modal sin seleccionar un ejecutivo
    Given que el responsable de facturación ingresa a la lista de encuentros
    And selecciona "<cantidad_encuentros>" encuentro
    And selecciona el botón "Asignar"
    When selecciona el botón "Cancelar" en el modal
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_CANCELAR_MODAL"
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And el rol del usuario
    And no registra ejecutivo para asignar el encuentro
    And se registra la cantidad de encuentros seleccionados
    Examples:
      | cantidad_encuentros |
      | 1 encuentro         |
      | 50 encuentros       |
      | 100 encuentros      |

  Scenario Outline: Registrar evento de taggeo al seleccionar el boton "clasificar"
    Given que el responsable de facturación ingresa a la lista de encuentros
    And selecciona "<cantidad_encuentros>" encuentro
    When selecciona el botón "Clasificar"
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_CLASIFICAR"
    #nombre, usuario, correo, fecha, hora, rol, cantidad de encuentros seleccionados
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And el rol del usuario
    And se registra la cantidad de encuentros seleccionados
    Examples:
      | cantidad_encuentros |
      | 1 encuentro         |
      | 50 encuentros       |
      | 100 encuentros      |

  Scenario Outline: Registrar evento de taggeo al seleccionar una opción de clasificación en el modal
    Given que el responsable de facturación ingresa a la lista de encuentros
    And selecciona "<cantidad_encuentros>" encuentro
    And selecciona el botón "Clasificar"
    When selecciona una opción de clasificación en el modal "<opcion_clasificacion>"
    Then se registra un evento de taggeo en amplitud con el nombre "CLASIFICACION_SELECCIONADA_MODAL"
    #nombre, usuario, correo, fecha, hora, rol, clasificación selecionada, cantidad de encuetros seleccionados
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And el rol del usuario
    And se registra la opcion de clasificacion seleccionado "<opcion_clasificacion>"
    And se registra la cantidad de encuentros seleccionados
    And se registra la opción de clasificación seleccionada

    Examples:
      | opcion_clasificacion      | cantidad_encuentros |
      | Facturar con hospitalario | 1 encuentro         |
      | Imp Fact Fin              | 50 encuentros       |
      | Imp Por Liq Fin His       | 100 encuentros      |
      | Pendiente en consulta     | 1 encuentro         |
      | Pendiente por convenio    | 1 encuentro         |
      | No Facturar               | 1 encuentro         |
      | Por Asignar               | 1 encuentro         |
      | No facturar farmacia      | 1 encuentro         |
      | No facturar Admision      | 1 encuentro         |

  Scenario Outline: Registrar evento de taggeo al confirmar la clasificación en el modal
    Given que el responsable de facturación ingresa a la lista de encuentros
    And selecciona "<cantidad_encuentros>" encuentro
    And selecciona el botón "Clasificar"
    And selecciona una opción de clasificación en el modal "<opcion_clasificacion>"
    When selecciona el botón "Confirmar" en el modal
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_CLASIFICAR_MODAL"
    #nombre, usuario, correo, fecha, hora, rol, clasificación selecionada, cantidad de encuetros seleccionados
    And se registra el nombre del usuario
    And se registra el usuario
    And se registra el correo del usuario
    And se registra la fecha y hora del evento
    And se registra el rol del usuario
    And se registra la opcion de clasificacion seleccionado "<opcion_clasificacion>"
    And se registra la cantidad de encuentros seleccionados
    Examples:
      | opcion_clasificacion      | cantidad_encuentros |
      | Facturar con hospitalario | 1 encuentro         |
      | Imp Fact Fin              | 50 encuentros       |
      | Imp Por Liq Fin His       | 100 encuentros      |
      | Pendiente en consulta     | 1 encuentro         |
      | Pendiente por convenio    | 1 encuentro         |
      | No Facturar               | 1 encuentro         |
      | Por Asignar               | 1 encuentro         |
      | No facturar farmacia      | 1 encuentro         |
      | No facturar Admision      | 1 encuentro         |

  Scenario Outline: Registrar evento de taggeo al cancelar la clasificación en el modal luego de seleccionar una opción de clasificación
    Given que el responsable de facturación ingresa a la lista de encuentros
    And selecciona "<cantidad_encuentros>" encuentro
    And selecciona el botón "Clasificar"
    And selecciona una opción de clasificación en el modal "<opcion_clasificacion>"
    When selecciona el botón "Cancelar" en el modal
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_CANCELAR_MODAL"
    #nombre, usuario, correo, fecha, hora, rol, clasificación selecionada, cantidad de encuetros seleccionados
    And se registra el nombre del usuario
    And se registra el usuario
    And se registra el correo del usuario
    And se registra la fecha y hora del evento
    And se registra el rol del usuario
    And se registra la opcion de clasificacion seleccionado "<opcion_clasificacion>"
    And se registra la cantidad de encuentros seleccionados
    Examples:
      | opcion_clasificacion      | cantidad_encuentros |
      | Facturar con hospitalario | 1 encuentro         |
      | Imp Fact Fin              | 50 encuentros       |
      | Imp Por Liq Fin His       | 100 encuentros      |
      | Pendiente en consulta     | 1 encuentro         |
      | Pendiente por convenio    | 1 encuentro         |
      | No Facturar               | 1 encuentro         |
      | Por Asignar               | 1 encuentro         |
      | No facturar farmacia      | 1 encuentro         |
      | No facturar Admision      | 1 encuentro         |

  Scenario Outline:  Registrar evento de taggeo al cancelar la clasificación en el modal sin seleccionar una opción de clasificación
    Given que el responsable de facturación ingresa a la lista de encuentros
    And selecciona "<cantidad_encuentros>" encuentro
    And selecciona el botón "Clasificar"
    When selecciona el botón "Cancelar" en el modal
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_CANCELAR_MODAL"
    #nombre, usuario, correo, fecha, hora, rol, cantidad de encuetros seleccionados
    And se registra el nombre del usuario
    And se registra el usuario
    And se registra el correo del usuario
    And se registra la fecha y hora del evento
    And se registra el rol del usuario
    And no se registra opción de clasificación seleccionada
    And se registra la cantidad de encuentros seleccionados

    Examples:
      | cantidad_encuentros |
      | 1 encuentro         |
      | 50 encuentros       |
      | 100 encuentros      |

  Scenario Outline: Registrar evento de taggeo al cancelar la clasificación con el boton "X" en el modal luego de seleccionar una opción de clasificación
    Given que el responsable de facturación ingresa a la lista de encuentros
    And selecciona "<cantidad_encuentros>" encuentro
    And selecciona el botón "Clasificar"
    And selecciona una opción de clasificación en el modal "<opcion_clasificacion>"
    When selecciona el botón "Cancelar" en el modal
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_CANCELAR_MODAL"
    #nombre, usuario, correo, fecha, hora, rol, clasificación selecionada, cantidad de encuetros seleccionados
    And se registra el nombre del usuario
    And se registra el usuario
    And se registra el correo del usuario
    And se registra la fecha y hora del evento
    And se registra el rol del usuario
    And se registra la opcion de clasificacion seleccionado "<opcion_clasificacion>"
    And se registra la cantidad de encuentros seleccionados
    Examples:
      | opcion_clasificacion      | cantidad_encuentros |
      | Facturar con hospitalario | 1 encuentro         |
      | Imp Fact Fin              | 50 encuentros       |
      | Imp Por Liq Fin His       | 100 encuentros      |
      | Pendiente en consulta     | 1 encuentro         |
      | Pendiente por convenio    | 1 encuentro         |
      | No Facturar               | 1 encuentro         |
      | Por Asignar               | 1 encuentro         |
      | No facturar farmacia      | 1 encuentro         |
      | No facturar Admision      | 1 encuentro         |

  Scenario Outline:  Registrar evento de taggeo al cancelar la clasificación con el boton "X" en el modal sin seleccionar una opción de clasificación
    Given que el responsable de facturación ingresa a la lista de encuentros
    And selecciona "<cantidad_encuentros>" encuentro
    And selecciona el botón "Clasificar"
    When selecciona el botón "Cancelar" en el modal
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_CANCELAR_MODAL"
    #nombre, usuario, correo, fecha, hora, rol, cantidad de encuetros seleccionados
    And se registra el nombre del usuario
    And se registra el usuario
    And se registra el correo del usuario
    And se registra la fecha y hora del evento
    And se registra el rol del usuario
    And no se registra opción de clasificación seleccionada
    And se registra la cantidad de encuentros seleccionados

    Examples:
      | cantidad_encuentros |
      | 1 encuentro         |
      | 50 encuentros       |
      | 100 encuentros      |

  @tag11
  Scenario: Registrar evento de taggeo al seleccionar el boton "Restablecer"
    Given que el responsable de facturación ingresa a la lista de encuentros
    When selecciona el botón "Restablecer"
    Then se registra un evento de taggeo en amplitud con el nombre "BOTON_CLICK_RESTABLECER_VISTA"
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And el rol del usuario

  @tag12
  Scenario: Registrar evento de taggeo al seleccionar el checkbox masivo para seleccionar todos los encuentros
    Given que el responsable de facturación ingresa a la lista de encuentros
    When selecciona el checkbox masivo para seleccionar todos los encuentros
    Then se registra un evento de taggeo en amplitud con el nombre "CHECKBOX_CAMBIO_MASIVO"
    #nombre, usuario, correo, fecha, hora, rol, cantidad de encuetros seleccionados
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And el rol del usuario
    And se registra la cantidad de encuentros seleccionados

  @tag12
  Scenario: Registrar evento de taggeo al seleccionar el checkbox masivo luego de realizar filtros
    Given que el responsable de facturación ingresa a la lista de encuentros
    And realiza un filtro por <filtro>
    When selecciona el checkbox masivo para seleccionar todos los encuentros filtrados
    Then se registra un evento de taggeo en amplitud con el nombre "CHECKBOX_CAMBIO_MASIVO"
    #nombre, usuario, correo, fecha, hora, rol, cantidad de encuetros seleccionados
    And se registra el nombre del usuario
    And se registra el usuario
    And el correo del usuario
    And la fecha y hora del evento
    And el rol del usuario
    And se registra la cantidad de encuentros seleccionados

    Examples:
      | filtro           |
      | nombre           |
      | apellido         |
      | nro de encuentro |
