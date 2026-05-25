# Petstore API Automation

Este repositorio contiene pruebas automatizadas de la API de Petstore usando:
- Serenity BDD (Screenplay)
- Cucumber / Gherkin
- REST (Serenity Rest/Rest-assured)

Este README explica cómo descargar el proyecto, requisitos previos, instalación de dependencias, ejecución de pruebas por tags y cómo ver los reportes.

----

## Índice
- Requisitos previos
- Instalación (Windows)
- Configurar variables de entorno (JAVA_HOME, MAVEN_HOME, PATH)
- Verificar instalación
- Ejecutar pruebas (comandos)
  - Ejecutar todas las pruebas
  - Ejecutar por TAG
  - Ejecutar un solo `Runner` o `Feature`
- Ver reportes Serenity
- Troubleshooting (errores comunes y soluciones)
- Notas sobre Stage/Actors (NoStageException)

----

## Requisitos previos
- Java JDK 17 (el proyecto está configurado para target Java 17). Tener Java 8 provoca errores de compilación ("invalid target release: 17").
- Apache Maven 3.6+ (preferible 3.8+).
- Conexión a internet para descargar dependencias Maven (la primera ejecución).

> Nota: en Windows, puedes instalar OpenJDK/Corretto/Amazon Corretto/Temurin (Java 17) y Apache Maven. Asegúrate de abrir una nueva terminal después de configurar variables de entorno.

----

## Instalación en Windows (resumen)

1) Instalar Java 17
- Descarga e instala un JDK 17 (por ejemplo Temurin/Adoptium, Amazon Corretto o Azul Zulu). Instala el MSI o ZIP según prefieras.

2) Instalar Maven
- Descarga Apache Maven y descomprime en una carpeta, por ejemplo `C:\Tools\apache-maven-3.8.8`.

3) Configurar variables de entorno (ejemplos para CMD / PowerShell)

Desde CMD (como administrador) puedes ejecutar:

```cmd
rem Ajusta las rutas según donde instalaste Java y Maven
setx JAVA_HOME "C:\Program Files\Java\jdk-17" /M
setx MAVEN_HOME "C:\Tools\apache-maven-3.8.8" /M
setx PATH "%PATH%;%JAVA_HOME%\bin;%MAVEN_HOME%\bin" /M
```

En PowerShell (ejecutar como administrador):

```powershell
# Ajusta las rutas según donde instalaste Java y Maven
setx JAVA_HOME "C:\Program Files\Java\jdk-17" -m
setx MAVEN_HOME "C:\Tools\apache-maven-3.8.8" -m
$old = [Environment]::GetEnvironmentVariable('Path','Machine')
[Environment]::SetEnvironmentVariable('Path', "$old;C:\Program Files\Java\jdk-17\bin;C:\Tools\apache-maven-3.8.8\bin", 'Machine')
```

Después de usar `setx`, cierra y abre una nueva terminal (CMD o PowerShell) para que las variables se apliquen.

----

## Verificar instalación

En una terminal nueva (CMD o PowerShell) ejecuta:

```cmd
java -version
mvn -version
```

Deberías ver Java 17 y una versión válida de Maven.

----

## Abrir el proyecto

Clona o descarga el repositorio y abre la carpeta raíz del proyecto (donde está el `pom.xml`).

----

## Ejecutar pruebas

Desde la raíz del proyecto, puedes ejecutar las pruebas con Maven.

Ejecutar todas las pruebas (limpio y forzar actualización de dependencias):

```cmd
mvn -U clean verify
```

Ejecutar por TAG (Windows CMD o PowerShell):
- Es importante no dejar un espacio entre `-D` y la propiedad. También es recomendable envolver el argumento en comillas.

```cmd
mvn -U clean verify "-Dcucumber.filter.tags=@po001"
```

Si usas PowerShell, la comilla doble con la propiedad también funciona:

```powershell
mvn -U clean verify "-Dcucumber.filter.tags=@po001"
```

Ejecutar un `Runner` o una clase de test concreta (si tu surefire/runner está configurado):

```cmd
mvn -Dtest=RunCucumberTest -DfailIfNoTests=false test
```

(Dependiendo de tu configuración de pom, el plugin de Serenity puede invocar verificaciones en la fase `verify`.)

----

## Ver reporte Serenity

Al terminar la ejecución, Serenity genera reportes HTML en:

```
target/site/serenity/index.html
```

Abre ese archivo en un navegador.

----

## Troubleshooting — Errores comunes y soluciones

1) mvn: El equipo no reconoce 'mvn' o "mvn no se reconoce como nombre de un cmdlet"
- Maven no está instalado o no está en la variable PATH. Verifica `mvn -version`.

2) Unknown lifecycle phase ".filter.tags=@po001"
- Esto ocurre cuando la propiedad `-Dcucumber.filter.tags=@po001` se pasa mal, por ejemplo con un espacio entre `-D` y la propiedad o sin comillas. Usa:

```cmd
mvn -U clean verify "-Dcucumber.filter.tags=@po001"
```

3) Fatal error compiling: invalid target release: 17
- Estás usando un JDK < 17 pero el proyecto está configurado con target 17. Instala JDK 17 y configura `JAVA_HOME` para que apunte a él.

4) NoStageException: "No stage available - it looks like you haven't called the setTheStage() method"
- En Screenplay debes inicializar el Stage antes de usar `theActorCalled(...)` o `theActorInTheSpotlight()`. Añade un Hook global en `src/test/java` parecido a:

```java
// ejemplo: src/test/java/com/example/hooks/SerenityHooks.java
import io.cucumber.java.Before;
import net.serenitybdd.screenplay.actors.OnStage;
import net.serenitybdd.screenplay.actors.OnlineCast;

public class SerenityHooks {
    @Before
    public void setTheStage() {
        OnStage.setTheStage(new OnlineCast());
    }
}
```

Esto asegura que el Stage esté inicializado para todos los escenarios.

5) Error al importar `net.serenitybdd.screenplay.abilities.CallAnApi` o dependencia `serenity-rest-assured` no encontrada
- Asegúrate de que en tu `pom.xml` tienes las dependencias con los `groupId` y `artifactId` correctos. Un ejemplo común de dependencias Serenity para REST (verifica versiones compatibles con tu proyecto):

```xml
<!-- Ejemplo: revisar versiones en tu pom.xml -->
<dependency>
  <groupId>net.serenity-bdd</groupId>
  <artifactId>serenity-screenplay</artifactId>
  <version>3.7.0</version>
</dependency>
<dependency>
  <groupId>net.serenity-bdd</groupId>
  <artifactId>serenity-rest-assured</artifactId>
  <version>3.7.0</version>
</dependency>
```

Si Maven no encuentra `serenity-rest-assured` en central, revisa que la versión exista y que no tengas un `repositories` mal configurado en `pom.xml`. Si usas una versión distinta, reemplázala por una existente o añade el repo correcto.

6) Respuesta JSON y validaciones (Questions vs Asserts)
- Para mantener el enfoque Screenplay, las validaciones sobre respuestas deberían exponerse como `Question`s que recuperen objetos (POJOs) deserializados y luego asserts en los Steps pueden usar esas Questions o usar `Ensure` de Serenity para validaciones más limpias.

----

## Recomendaciones para aumentar cobertura / unhappy paths
- Añadir features que prueben respuestas 4xx/5xx.
- Añadir `Questions` que deserialicen errores y mensajes y validen los campos.
- Añadir tests para DELETE, GET no existente, POST con datos inválidos, etc.

----

## Ejemplo rápido de comandos para verificar todo (paso a paso)

1) Verificar Java y Maven:
```cmd
java -version
mvn -version
```

2) Limpiar, descargar dependencias y ejecutar pruebas con tag `@po001`:
```cmd
mvn -U clean verify "-Dcucumber.filter.tags=@po001"
```

3) Abrir reporte:
- Abrir `target\site\serenity\index.html` en tu navegador.

----

Si quieres, puedo:
- Añadir el `Hook` de inicialización del Stage en `src/test/java/com/example/hooks/SerenityHooks.java` (si no existe) para resolver la `NoStageException`.
- Revisar y proponer los cambios necesarios en `pom.xml` para corregir dependencias faltantes (`serenity-rest-assured` / `serenity-screenplay`), o fijar versiones compatibles.

Dime si quieres que cree esos cambios automáticamente en el proyecto y los pruebe (necesitaré ejecutar `mvn` en el workspace para validar).

----

Fin del README.

