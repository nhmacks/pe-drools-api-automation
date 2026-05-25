@auth
Feature: Endpoint de registro de usuarios
  Como nuevo usuario
  Quiero registrar una nueva cuenta
  Para poder acceder a la aplicación

  @auth_register @happy @ru001
  Scenario Outline: Registro de usuario exitoso
    When el usuario intenta registrarse con los siguientes datos:
      | email   | password   | firstName   | lastName   | phone   |
      | <email> | <password> | <firstName> | <lastName> | <phone> |
    Then el estado de respuesta del registro debe ser 201
    And el usuario debe estar registrado exitosamente
    And el email registrado debe ser "<email>"
    And el firstName registrado debe ser "<firstName>"
    And el lastName registrado debe ser "<lastName>"
    And el phone registrado debe ser "<phone>"
    And el usuario debe tener el rol por defecto "CUSTOMER"
    And el email del usuario no debe estar verificado
    And el usuario debe estar activo
    And el usuario debe tener un timestamp createdAt válido

    Examples: Escenarios válidos de registro
      | email                              | password     | firstName | lastName | phone                |
      | testuser{timestamp}@mailinator.com | Peru123.     | Test      | User     | +51{randomPeruPhone} |
      | johndoe{timestamp}@mailinator.com  | SecurePass1. | John      | Doe      | +51{randomPeruPhone} |
      | sarah{timestamp}@mailinator.com    | MyPass2024!  | Sarah     | Smith    | +51{randomPeruPhone} |

  @auth_register @unhappy @ru002
  Scenario: Registro falla cuando el email está vacío
    When el usuario intenta registrarse con los siguientes datos:
      | email | password | firstName | lastName | phone                |
      |       | Peru123. | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "email"

  @auth_register @unhappy @ru003
  Scenario: Registro falla cuando la contraseña está vacía
    When el usuario intenta registrarse con los siguientes datos:
      | email                  | password | firstName | lastName | phone                |
      | nhmacks+test@gmail.com |          | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "password"

  @auth_register @unhappy @ru004
  Scenario: Registro falla cuando el email tiene formato inválido
    When el usuario intenta registrarse con los siguientes datos:
      | email         | password | firstName | lastName | phone                |
      | invalid-email | Peru123. | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "email"

  @auth_register @unhappy @ru005
  Scenario Outline: Registro falla cuando falta el dominio en el email
    When el usuario intenta registrarse con los siguientes datos:
      | email   | password | firstName | lastName | phone                |
      | <email> | Peru123. | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "email"

    Examples:
      | email        |
      | test@invalid |
      | user@.com    |
      | @domain.com  |

  @auth_register @unhappy @ru006
  Scenario: Registro falla cuando firstName está vacío
    When el usuario intenta registrarse con los siguientes datos:
      | email                  | password | firstName | lastName | phone                |
      | nhmacks+test@gmail.com | Peru123. |           | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "firstName"

  @auth_register @unhappy @ru007
  Scenario: Registro falla cuando lastName está vacío
    When el usuario intenta registrarse con los siguientes datos:
      | email                  | password | firstName | lastName | phone                |
      | nhmacks+test@gmail.com | Peru123. | Test      |          | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "lastName"

  @auth_register @happy @ru008
  Scenario Outline: Registro exitoso cuando phone no es provisto (campo opcional)
    When el usuario intenta registrarse con los siguientes datos:
      | email   | password     | firstName | lastName | phone |
      | <email> | SecurePass1. | Jane      | Doe      |       |
    Then el estado de respuesta del registro debe ser 201
    And el usuario debe estar registrado exitosamente
    And el email registrado debe ser "<email>"
    And el firstName registrado debe ser "Jane"
    And el lastName registrado debe ser "Doe"
    And el usuario debe tener el rol por defecto "CUSTOMER"
    And el usuario debe estar activo
    Examples:
      | email                                 |
      | optional.phone{timestamp}@example.com |

  @auth_register @happy @ru021
  Scenario Outline: Registro acepta formato E.164 de phone
    When el usuario intenta registrarse con los siguientes datos:
      | email   | password     | firstName | lastName | phone   |
      | <email> | SecurePass1. | Test      | User     | <phone> |
    Then el estado de respuesta del registro debe ser 201
    And el usuario debe estar registrado exitosamente
    And el email registrado debe ser "<email>"
    And el phone registrado debe ser "<phone>"
    Examples:
      | email                                 | phone                |
      | e164.valid1{timestamp}@mailinator.com | +51{randomPeruPhone} |
  #| e164.valid2{timestamp}@mailinator.com | +14{randomPeruPhone} |

  @auth_register @unhappy @ru022
  Scenario: Registro falla cuando phone no tiene el signo plus
    When el usuario intenta registrarse con los siguientes datos:
      | email                                 | password     | firstName | lastName | phone       |
      | e164.noplus{timestamp}@mailinator.com | SecurePass1. | Test      | User     | 51987654321 |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "phone"

  @auth_register @unhappy @ru023
  Scenario: Registro falla cuando phone contiene caracteres no numéricos
    When el usuario intenta registrarse con los siguientes datos:
      | email                                | password     | firstName | lastName | phone       |
      | e164.alpha{timestamp}@mailinator.com | SecurePass1. | Test      | User     | +51A7654321 |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "phone"

  @auth_register @unhappy @ru024
  Scenario: Registro falla cuando phone excede 15 dígitos
    When el usuario intenta registrarse con los siguientes datos:
      | email                               | password     | firstName | lastName | phone             |
      | e164.long{timestamp}@mailinator.com | SecurePass1. | Test      | User     | +1234567890123456 |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "phone"

  @auth_register @unhappy @ru009
  Scenario: Registro falla cuando la contraseña es débil (sin mayúsculas)
    When el usuario intenta registrarse con los siguientes datos:
      | email                             | password | firstName | lastName | phone                |
      | nhmacks+test{timestamp}@gmail.com | peru123. | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And el error debe contener mensaje que contenga "password"

  @auth_register @unhappy @ru010
  Scenario: Registro falla cuando la contraseña es débil (sin caracter especial)
    When el usuario intenta registrarse con los siguientes datos:
      | email                             | password | firstName | lastName | phone                |
      | nhmacks+test{timestamp}@gmail.com | Peru1234 | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And el error debe contener mensaje que contenga "password"

  @auth_register @unhappy @ru011
  Scenario: Registro falla cuando la contraseña es demasiado corta
    When el usuario intenta registrarse con los siguientes datos:
      | email                             | password | firstName | lastName | phone                |
      | nhmacks+test{timestamp}@gmail.com | P1.      | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And el error debe contener mensaje que contenga "password: La contraseña debe tener entre 8 y 72 caracteres"

  @auth_register @unhappy @ru012
  Scenario: Registro falla cuando el email ya está registrado
    When el usuario intenta registrarse con los siguientes datos:
      | email             | password | firstName | lastName | phone                |
      | nhmacks@gmail.com | Peru123. | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 409
    And la respuesta de error debe indicar "Email ya registrado"

  @auth_register @security @ru013
  Scenario: Intento de inyección SQL en el campo email
    When el usuario intenta registrarse con los siguientes datos:
      | email                     | password | firstName | lastName | phone                |
      | test' OR '1'='1@gmail.com | Peru123. | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "email"

  @auth_register @security @ru014
  Scenario: Intento de XSS en el campo firstName
    When el usuario intenta registrarse con los siguientes datos:
      | email                             | password | firstName                | lastName | phone                |
      | nhmacks+test{timestamp}@gmail.com | Peru123. | <script>alert()</script> | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "firstName"

  @auth_register @security @ru015
  Scenario: Intento de XSS en el campo lastName
    When el usuario intenta registrarse con los siguientes datos:
      | email                             | password | firstName | lastName              | phone                |
      | nhmacks+test{timestamp}@gmail.com | Peru123. | Test      | <img src=x onerror=1> | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "lastName"

  @auth_register @security @ru016
  Scenario: Intento de inyección de comandos en el campo phone
    When el usuario intenta registrarse con los siguientes datos:
      | email                             | password | firstName | lastName | phone               |
      | nhmacks+test{timestamp}@gmail.com | Peru123. | Test      | User     | 982113735; rm -rf / |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "phone"

  @auth_register @security @ru017
  Scenario: Entrada muy larga en el campo email (posible desbordamiento de búfer)
    When el usuario intenta registrarse con los siguientes datos:
      | email                                                                                                                                                 | password | firstName | lastName | phone                |
      | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@gmail.com | Peru123. | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "email"

#REVISAR POR QUE FALLA ESTE TEST#REVISAR POR QUE FALLA ESTE TEST
  #@auth_register @security @ru018
  #Scenario: Special characters in firstName should be rejected or sanitized
  #  When the user attempts to register with the following data:
  #    | email                             | password | firstName     | lastName | phone            |
  #    | nhmacks+test{timestamp}@gmail.com | Peru123. | Test@#$%^&*() | User     | +51{randomPeruPhone} |
  #  Then the registration response status should be 400
  #  And the error response should indicate "firstName"

  @auth_register @security @ru019
  Scenario: Password with spaces should be handled correctly
    When el usuario intenta registrarse con los siguientes datos:
      | email                             | password     | firstName | lastName | phone                |
      | nhmacks+test{timestamp}@gmail.com | Peru 123.456 | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And el error debe contener mensaje que contenga "password"

  @auth_register @security @ru020
  Scenario: Unicode characters in names should be accepted if allowed
    When el usuario intenta registrarse con los siguientes datos:
      | email                             | password | firstName | lastName | phone                |
      | nhmacks+test{timestamp}@gmail.com | Peru123. | José      | García   | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 201
    And el usuario debe estar registrado exitosamente

  @auth_register @happy @ru025
  Scenario: Registration accepts email at max length (254 chars)
    When el usuario intenta registrarse con los siguientes datos:
      | email                                                                         | password     | firstName | lastName | phone                |
      | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa{timestamp}@longdomain.com | SecurePass1. | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 201
    And el usuario debe estar registrado exitosamente
    And el email registrado debe ser "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa{timestamp}@longdomain.com"

  @auth_register @unhappy @ru026
  Scenario: Registration fails when email exceeds max length
    When el usuario intenta registrarse con los siguientes datos:
      | email                                                                                                                                                                                                                                                         | password     | firstName | lastName | phone                |
      | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa{timestamp}@longdomain.com | SecurePass1. | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "email"

  @auth_register @happy @ru027
  Scenario: Registration accepts firstName at max length (100 chars)
    When el usuario intenta registrarse con los siguientes datos:
      | email                               | password     | firstName                                                                                            | lastName | phone                |
      | fname.max{timestamp}@mailinator.com | SecurePass1. | AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 201
    And el firstName registrado debe ser "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

  @auth_register @unhappy @ru028
  Scenario: Registration fails when firstName exceeds max length
    When el usuario intenta registrarse con los siguientes datos:
      | email                                | password     | firstName                                                                                             | lastName | phone                |
      | fname.long{timestamp}@mailinator.com | SecurePass1. | BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "firstName"

  @auth_register @happy @ru029
  Scenario: Registration accepts lastName at max length (100 chars)
    When el usuario intenta registrarse con los siguientes datos:
      | email                               | password     | firstName | lastName                                                                                           | phone                |
      | lname.max{timestamp}@mailinator.com | SecurePass1. | Test      | CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 201
    And el lastName registrado debe ser "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"

  @auth_register @unhappy @ru030
  Scenario: Registration fails when lastName exceeds max length
    When el usuario intenta registrarse con los siguientes datos:
      | email                                | password     | firstName | lastName                                                                                              | phone                |
      | lname.long{timestamp}@mailinator.com | SecurePass1. | Test      | DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "lastName"

  @auth_register @happy @ru031
  Scenario: Validar registro de telefono internacional en max length (13 chars)
    When el usuario intenta registrarse con los siguientes datos:
      | email                               | password     | firstName | lastName | phone                  |
      | phone.max{timestamp}@mailinator.com | SecurePass1. | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 201
    And el phone registrado debe ser "+881{randomPeruPhone}"


  @auth_register @unhappy @ru032
  Scenario: Registration fails when phone exceeds max length (20 chars)
    When el usuario intenta registrarse con los siguientes datos:
      | email                                | password     | firstName | lastName | phone                 |
      | phone.long{timestamp}@mailinator.com | SecurePass1. | Test      | User     | +12345678901234567890 |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "phone"

  @auth_register @happy @ru033
  Scenario: Registration accepts password at max length (72 chars)
    When el usuario intenta registrarse con los siguientes datos:
      | email                             | password                                                                 | firstName | lastName | phone                |
      | pwd.max{timestamp}@mailinator.com | Abc123!?Abc123!?Abc123!?Abc123!?Abc123!?Abc123!?Abc123!?Abc123!?Abc123!? | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 201
    And el usuario debe estar registrado exitosamente

  @auth_register @unhappy @ru034
  Scenario: Registration fails when password exceeds max length (73 chars)
    When el usuario intenta registrarse con los siguientes datos:
      | email                              | password                                                                  | firstName | lastName | phone                |
      | pwd.long{timestamp}@mailinator.com | Abc123!?Abc123!?Abc123!?Abc123!?Abc123!?Abc123!?Abc123!?Abc123!?Abc123!?X | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And el error debe contener mensaje que contenga "password"

    # ========== NUEVOS ESCENARIOS DE CALIDAD Y SEGURIDAD ==========

  @auth_register @auth_trim @unhappy @ru035
  Scenario: Registration handles email with leading/trailing spaces
    When el usuario intenta registrarse con los siguientes datos:
      | email                                | password     | firstName | lastName | phone                |
      | trim.email{timestamp}@mailinator.com | SecurePass1. | Test      | User     | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 201
    And el email registrado debe ser sin espacios

  @auth_register @auth_trim @unhappy @ru036
  Scenario: Registration handles firstName with extra spaces
    When el usuario intenta registrarse con los siguientes datos:
      | email                                | password     | firstName | lastName | phone                |
      | trim.fname{timestamp}@mailinator.com | SecurePass1. | Test User | Smith    | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 201
    And el firstName registrado no debe contener espacios extra

  @auth_register @auth_trim @unhappy @ru037
  Scenario: Registration handles lastName with extra spaces
    When el usuario intenta registrarse con los siguientes datos:
      | email                                | password     | firstName | lastName  | phone                |
      | trim.lname{timestamp}@mailinator.com | SecurePass1. | Test      | Smith Doe | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 201
    And el lastName registrado no debe contener espacios extra

  @auth_register @auth_case @unhappy @ru038
  Scenario: Registration detects duplicate email with different case
    Given el usuario intenta registrarse con los siguientes datos:
      | email                              | password     | firstName | lastName | phone                |
      | casetest{timestamp}@mailinator.com | SecurePass1. | Test      | User     | +51{randomPeruPhone} |
    When el usuario intenta registrarse con los mismos datos exactamente de nuevo
    Then el estado de respuesta del registro debe ser 409
    And la respuesta de error debe indicar "Email ya registrado"

  @auth_register @auth_unicode @security @ru039
  Scenario: Registration normalizes unicode characters (NFC vs NFD)
    When el usuario intenta registrarse con los siguientes datos:
      | email                                  | password     | firstName | lastName | phone                |
      | unicode.norm{timestamp}@mailinator.com | SecurePass1. | José      | García   | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 201
    And el firstName registrado debe ser normalizado

#REVISAR POR QUE FALLA ESTE TEST
  #@auth_register @auth_content_type @unhappy @ru040
  #Scenario: Registration fails when Content-Type header is missing
  #  When the user sends a registration request without Content-Type header:
  #    | email                              | password     | firstName | lastName | phone            |
  #    | no.ctype{timestamp}@mailinator.com | SecurePass1. | Test      | User     | +51{randomPeruPhone} |
  #  Then the registration response status should be 415

#REVISAR POR QUE FALLA ESTE TEST
  @auth_register @auth_content_type @unhappy @ru041
  #Scenario: Registration fails when Content-Type is incorrect
  #  When the user sends a registration request with Content-Type "text/plain":
  #    | email                                 | password     | firstName | lastName | phone            |
  #    | wrong.ctype{timestamp}@mailinator.com | SecurePass1. | Test      | User     | +51{randomPeruPhone} |
  #  Then the registration response status should be 415

  @auth_register @auth_malformed @unhappy @ru042
  Scenario: Registration fails with malformed JSON
    When el usuario envía una solicitud de registro JSON malformada
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error debe indicar "malformed"

  @auth_register @auth_http_verbs @unhappy @ru043
  Scenario Outline: Registration endpoint rejects non-POST HTTP methods
    When el usuario envía una solicitud <method> al endpoint de registro
    Then el estado de respuesta del registro debe ser 405
    Examples:
      | method |
      | GET    |
      | PUT    |
      | PATCH  |
      | DELETE |

  #@auth_register @auth_password_policy @unhappy @ru044
  #Scenario Outline: Registration fails with common dictionary passwords
  #  When el usuario intenta registrarse con los siguientes datos:
  #    | email                              | password   | firstName | lastName | phone                |
  #    | dict.pwd{timestamp}@mailinator.com | <password> | Test      | User     | +51{randomPeruPhone} |
  #  Then el estado de respuesta del registro debe ser 400
  #  And el error debe contener mensaje que contenga "password"
#
  #  Examples:
  #    | password     |
  #    | Password123! |
  #    | Qwerty123!   |
  #    | Admin123!    |
  #    | Welcome123!  |
  #    | Letmein123!  |

    #@auth_register @auth_domain @unhappy @ru045
    #Scenario: Registration validates email domain existence
    #    When the user attempts to register with the following data:
    #        | email                                      | password    | firstName | lastName | phone        |
    #        | test{timestamp}@thisdoesnotexist99999.fake | SecurePass1. | Test      | User     | +51987654321 |
    #    Then the registration response status should be 400
    #    And the error response should indicate "email"

  @auth_register @auth_phone_validation @unhappy
  Scenario Outline: Registration fails with invalid E.164 country code
    When el usuario intenta registrarse con los siguientes datos:
      | email                                | password       | firstName | lastName | phone   |
      | phone.e164{timestamp}@mailinator.com | ValidP@ssw0rd! | Test      | User     | <phone> |
    Then el estado de respuesta del registro debe ser 400
    And el error debe contener mensaje que contenga "phone"

    Examples:
      | phone        |
      | +00987654321 |
      #| +999987654321  |
      #| +1234987654321 |
      | 51987654321  |

  @auth_register @auth_race @security @ru047
  Scenario: Registration handles concurrent duplicate email submissions
    When dos usuarios intentan registrarse simultáneamente con el mismo email
    Then un registro debe tener éxito con estado 201
    And el otro registro debe fallar con estado 409

  @auth_register @auth_error_exposure @security @ru048
  Scenario: Error responses do not expose sensitive information
    When el usuario intenta registrarse con datos inválidos:
      | email         | password | firstName | lastName | phone                |
      | invalid-email | Peru123. |           |          | +51{randomPeruPhone} |
    Then el estado de respuesta del registro debe ser 400
    And la respuesta de error no debe contener trazas de pila
    And la respuesta de error no debe contener rutas internas

  @auth_register @auth_headers @security @ru049
  Scenario: Registration response includes security headers
    When el usuario intenta registrarse con los siguientes datos:
      | email                                  | password  | firstName | lastName | phone                |
      | security.hdr{timestamp}@mailinator.com | Peru123.. | Test      | User     | +51{randomPeruPhone} |
    Then la respuesta debe incluir el encabezado de seguridad "Cache-Control" con valor "no-store"
    And la respuesta debe incluir el encabezado de seguridad "X-Content-Type-Options" con valor "nosniff"
    And la respuesta debe incluir el encabezado de seguridad "X-Frame-Options"

  @auth_register @auth_null @unhappy @ru050
  Scenario: Registration handles phone as JSON null
    When el usuario envía una solicitud de registro con phone como null:
      | email                                | password  | firstName | lastName |
      | phone.null{timestamp}@mailinator.com | Peru123.. | Test      | User     |
    Then el estado de respuesta del registro debe ser 201
    And el usuario debe estar registrado exitosamente

  @auth_register @auth_idempotency @unhappy @ru051
  Scenario: Registration is idempotent based on email
    Given el usuario intenta registrarse con los siguientes datos:
      | email                                | password | firstName | lastName | phone                |
      | idempotent{timestamp}@mailinator.com | Peru123. | Test      | User     | +51{randomPeruPhone} |
    When el usuario intenta registrarse con los mismos datos exactamente de nuevo
    Then el estado de respuesta del registro debe ser 409
    And la respuesta de error debe indicar "Email ya registrado"

