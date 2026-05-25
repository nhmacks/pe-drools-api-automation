@login
Feature: Endpoint de autenticación (Login)
  Como usuario
  Quiero autenticarme con credenciales válidas
  Para obtener tokens de acceso y refresh

  @lo001 @happy-path @smoke
  Scenario Outline: Inicio de sesión exitoso con credenciales válidas
    Given el usuario existe registrado con email:
      | email   | password   | firstName | lastName | phone                |
      | <email> | <password> | Test      | User     | +51{randomPeruPhone} |
    When el usuario intenta iniciar sesion con email y password válidos
    Then el estado de respuesta del login debe ser 200
    And la respuesta debe contener un access token válido
    And la respuesta debe contener un refresh token válido
    And el tipo de token debe ser "Bearer"
    And el valor expiresIn debe ser mayor que 0

    Examples:
      | email                              | password     |
      | testuser{timestamp}@mailinator.com | Peru123.     |
      | johndoe{timestamp}@mailinator.com  | SecurePass1. |
      | sarah{timestamp}@mailinator.com    | MyPass2024!  |

  @lo002 @happy-path
  Scenario Outline: La respuesta incluye todos los campos requeridos del token
    Given el usuario existe registrado con email:
      | email   | password   | firstName | lastName | phone                |
      | <email> | <password> | Test      | User     | +51{randomPeruPhone} |
    When cuando el usuario proporciona credenciales válidas con email y password
    Then el estado de respuesta del login debe ser 200
    And la respuesta debe incluir todos los campos requeridos de token
    Examples:
      | email                              | password |
      | testuser{timestamp}@mailinator.com | Peru123. |

  # ========== UNHAPPY PATH - CREDENCIALES INVÁLIDAS ==========

  @lo004 @unhappy-path @negative
  Scenario: Login falla con contraseña incorrecta
    Given el usuario existe registrado con email:
      | email                              | password | firstName | lastName | phone                |
      | testuser{timestamp}@mailinator.com | Peru123. | Test      | User     | +51{randomPeruPhone} |
    When cuando el usuario intenta iniciar sesion con email inválido "testuser{timestamp}@mailinator.com" y password "Peru123."
    Then el estado de respuesta del login debe ser no autorizado 401
    And la respuesta debe contener un mensaje de error
    And el mensaje de error debe indicar credenciales inválidas

  @lo005 @unhappy-path @negative
  Scenario: Login falla con email inexistente
    When cuando el usuario intenta iniciar sesion con email inválido "nonexistent@example.com" y password "Test123456"
    Then el estado de respuesta del login debe ser no autorizado 401
    And la respuesta debe contener un mensaje de error

  @lo006 @unhappy-path @negative
  Scenario: Login falla con campo email vacío
    When el usuario intenta iniciar sesion con email vacío y password "Test123456"
    Then el estado de respuesta del login debe ser no autorizado 400
    And la respuesta debe contener un mensaje de error

  @lo007 @unhappy-path @negative
  Scenario: Login falla con campo password vacío
    When el usuario intenta iniciar sesion con email "test@example.com" y password vacío
    Then el estado de respuesta del login debe ser no autorizado 400
    And la respuesta debe contener un mensaje de error

  @lo008 @unhappy-path @negative
  Scenario: Login falla cuando email y password están vacíos
    When el usuario intenta iniciar sesion con email y password ambos vacíos
    Then el estado de respuesta del login debe ser no autorizado 400
    And la respuesta no debe contener ningún token

  # ========== UNHAPPY PATH - ERRORES DE VALIDACIÓN ==========

  @lo009 @unhappy-path @validation
  Scenario: Login falla con formato de email malformado
    When el usuario intenta iniciar sesion con email mal formado "notanemail"
    Then el estado de respuesta del login debe ser no autorizado 400
    And la respuesta debe contener un mensaje de error

  # ========== SEGURIDAD - INYECCIÓN SQL ==========

  @lo011 @security @sql-injection
  Scenario: La API protege contra inyección SQL en el campo email
    When el usuario intenta inyectar SQL en el campo email con "admin'--"
    Then la respuesta debe ser rechazada con estado 400
    And la API no debe exponer información sensible en los mensajes de error

  @lo012 @security @sql-injection
  Scenario: La API protege contra inyección SQL con sentencia UNION
    When el usuario intenta inyectar SQL en el campo email con "' UNION SELECT * FROM users--"
    Then la respuesta debe ser rechazada con estado 400
    And la API no debe exponer información sensible en los mensajes de error

  # ========== SEGURIDAD - XSS ==========

  @lo013 @security @xss
  Scenario: La API protege contra XSS en el campo email
    When el usuario intenta inyectar script en el campo email con "<script>alert('xss')</script>"
    Then la respuesta debe ser rechazada con estado 400
    And la API no debe exponer información sensible en los mensajes de error

  @lo014 @security @xss
  Scenario: La API protege contra inyección vía event handler
    When el usuario intenta inyectar script en el campo email con "javascript:alert('xss')"
    Then la respuesta debe ser rechazada con estado 400

  # ========== SEGURIDAD - BRUTE FORCE ==========
  Rule: El control de tiempo de bloqueo es un mecanismo de seguridad que limita temporalmente los intentos de autenticación tras múltiples fallos consecutivos, gestionado exclusivamente por el backend, utilizando contadores temporales con expiración automática, y respondiendo con mensajes genéricos para evitar la exposición de información sensible.
    @lo015 @security @brute-force
    Scenario Outline: La API protege contra ataques de fuerza bruta
      Given el usuario existe registrado con email:
        | email   | password   | firstName | lastName | phone                |
        | <email> | <password> | Test      | User     | +51{randomPeruPhone} |
      When el usuario intenta un ataque de fuerza bruta con 6 intentos fallidos
      Then la respuesta debe indicar limitación de tasa o bloqueo de cuenta
      And la API no debe exponer información sensible en los mensajes de error
      Examples:
        | email                              | password |
        | testuser{timestamp}@mailinator.com | Peru123. |

  # ========== SEGURIDAD - CAMPOS REQUERIDOS ==========

    @lo016 @security @validation
    Scenario: La API rechaza petición sin cuerpo de credenciales
      When el usuario intenta iniciar sesion sin enviar el cuerpo de credenciales
      Then la respuesta debe indicar campos requeridos faltantes

  # ========== CASOS LÍMITE ==========

    @lo017 @edge-case
    Scenario: Login con email que contiene caracteres especiales
      When cuando el usuario intenta iniciar sesion con email inválido "test+alias@example.com" y password "Test123456"
      Then el estado de respuesta del login debe ser no autorizado 401

    #@lo018 @edge-case
    #Scenario: Login con password muy largo
    #  When cuando el usuario intenta iniciar sesion con email inválido "test@example.com" y password "A1234567890123456789012345678901234567890123456789012345678901234567890123456789"
    #  Then el estado de respuesta del login debe ser no autorizado 401

    @lo019 @edge-case
    Scenario Outline: Login con email en mayúsculas
      Given el usuario existe registrado con email:
        | email   | password   | firstName | lastName | phone                |
        | <email> | <password> | Test      | User     | +51{randomPeruPhone} |
      When el usuario proporciona credenciales válidas con email en mayúsculas
      Then el estado de respuesta del login debe ser 200
      And la respuesta debe contener un access token válido
      Examples:
        | email                              | password     |
        | tester{timestamp}@mailinator.com   | Peru123.     |
        | johndoer{timestamp}@mailinator.com | SecurePass1. |
        | sarahs{timestamp}@mailinator.com   | MyPass2024!  |

    @lo020 @edge-case @case-sensitive
    Scenario: Verificar que la contraseña es case-sensitive
      Given el usuario existe registrado con email:
        | email                              | password  | firstName | lastName | phone                |
        | testuser{timestamp}@mailinator.com | Peru123.- | Test      | User     | +51{randomPeruPhone} |
      When el usuario intenta iniciar sesion con la contraseña en mayusculas
      #When cuando el usuario intenta iniciar sesion con email inválido "test@example.com" y password "test123456"
      Then el estado de respuesta del login debe ser no autorizado 401
      And la respuesta debe contener un mensaje de error

    @lo021 @security @protocol
    Scenario: Login falla cuando Content-Type no es application/json
      When el usuario intenta iniciar sesion con Content-Type "text/plain"
      Then el estado de respuesta del login debe ser 415
      And la respuesta debe contener un mensaje de error

    @lo022 @security @protocol
    Scenario: Login falla cuando falta la cabecera Content-Type
      When el usuario intenta iniciar sesion sin la cabecera Content-Type
      Then el estado de respuesta del login debe ser 415
      And la respuesta debe contener un mensaje de error

    @lo023 @validation
    Scenario: Login falla con cuerpo JSON vacío
      When el usuario intenta iniciar sesion con cuerpo JSON vacío
      Then el estado de respuesta del login debe ser 400
      And la respuesta debe indicar un cuerpo de petición inválido o mal formado

    @lo024 @security @validation
    Scenario: Login falla cuando campos inesperados están presentes
      When el usuario intenta iniciar sesion con campo extra "role" establecido a "admin"
      Then el estado de respuesta del login debe ser 400
      And la API no debe procesar campos inesperados

    @lo025 @validation
    Scenario: Login falla cuando email no es una cadena
      When el usuario intenta iniciar sesion con email como número 12345
      Then el estado de respuesta del login debe ser 400
      And la respuesta debe contener un mensaje de error

    #@lo026 @validation
    #Scenario: Login elimina espacios en blanco del email
    #  Given el usuario existe registrado con email "test@example.com"
    #  When el usuario intenta iniciar sesion con email " test@example.com " y password "Peru123."
    #  Then el estado de respuesta del login debe ser 200

    @lo027 @security
    Scenario: El tiempo de respuesta de login es consistente para usuario inválido y contraseña inválida
      When el usuario intenta iniciar sesion con email inexistente
      And el usuario intenta iniciar sesion con email válido pero contraseña incorrecta
      Then ambas respuestas deben tener tiempos de respuesta similares

    #@lo028 @security @brute-force
    #Scenario: Login tiene éxito después de que expire el tiempo de bloqueo por fuerza bruta
    #  Given el usuario fue bloqueado debido a múltiples intentos fallidos de inicio de sesión
    #  When expira el tiempo de bloqueo
    #  And el usuario intenta iniciar sesion con credenciales válidas
    #  Then el estado de respuesta del login debe ser 200

    @lo029 @security @brute-force
    Scenario: El bloqueo por fuerza bruta no afecta a otros usuarios
      Given el usuario A dispara la protección por fuerza bruta
      When el usuario B intenta iniciar sesion con credenciales válidas
      Then el estado de respuesta del login debe ser 200

    #@lo030 @security @token
    #Scenario: Los access tokens son únicos por inicio de sesión
    #  When el usuario inicia sesion dos veces con credenciales válidas
    #  Then cada access token debe ser diferente

    @lo031 @security @token
    Scenario: Token de acceso expirado es rechazado
      Given el usuario tiene un token de acceso expirado
      When el usuario accede a un endpoint protegido
      Then el estado de respuesta debe ser no autorizado 401

    @lo032 @security @token
    Scenario: El refresh token no puede ser reutilizado
      Given el usuario refresca el token de acceso exitosamente
      When se usa de nuevo el mismo refresh token
      Then el estado de respuesta debe ser no autorizado 401

    @lo033 @security
    Scenario: Las respuestas de error de login siguen una estructura consistente
      When el usuario intenta iniciar sesion con credenciales inválidas
      Then la respuesta de error debe cumplir el contrato estándar de error
