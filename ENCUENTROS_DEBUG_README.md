# Consulta de Encuentros - Endpoint Debug

## Descripción

Esta funcionalidad permite consultar los detalles de encuentros desde el endpoint de producción `/api/v3/debug/detail/{visitOccurrenceId}` y generar automáticamente:

📋 **Un archivo índice principal** (`index.html`) que se actualiza automáticamente después de cada consulta, listando todos los encuentros con links directos a sus detalles

📄 **Reportes HTML individuales** con todas las tablas del response organizadas visualmente

Todo con:
- 🚀 **Generación automática** - Solo ejecutas un comando y todo se genera
- 🎨 **Diseño moderno** - Interfaz visual atractiva con gradientes
- 🔗 **Navegación intuitiva** - Links directos del índice a cada detalle
- 📅 **Nombres únicos** - Cada archivo tiene timestamp para evitar sobrescrituras

## ¿Cómo usar?

### 1. Agregar encuentros a consultar

Edita el archivo `src/test/resources/features/encounters/encuenter_prod.feature` y agrega los IDs de los encuentros que deseas consultar en la sección `Examples`:

```gherkin
Examples:
  | visit_occurrence_id |
  | 128800388           |
  | 128800389           |
  | 128800390           |
```

Los nombres de los archivos HTML se generarán automáticamente usando el patrón:
`{visit_occurrence_id}_{YYYYMMDD_HHmmssSSS}.html`

Por ejemplo: `128800388_20260727_143052123.html`

### 2. Ejecutar las pruebas

**Comando único:**

```bash
mvn clean test -Dcucumber.filter.tags="@debug001"
```

Esto ejecutará automáticamente:
1. ✨ **Limpia** la lista de encuentros (solo la primera vez)
2. 📄 **Consulta** cada encuentro según las filas en Examples
3. 💾 **Genera** el archivo HTML de detalle de cada encuentro
4. 📋 **Actualiza** el archivo `index.html` después de cada encuentro consultado

Al finalizar, tendrás:
- ✅ Un archivo `index.html` con todos los encuentros listados
- ✅ Un archivo de detalle por cada encuentro consultado
- ✅ Links funcionales desde el índice hacia cada detalle

### 3. Ver los reportes HTML generados

Los reportes HTML se generarán automáticamente en la carpeta:

```
target/encounter-reports/
```

#### 📋 Archivo Índice Principal

Se genera automáticamente un archivo **`index.html`** que:
- Lista todos los encuentros consultados en la ejecución
- Muestra información resumida de cada encuentro
- Incluye links directos a cada reporte detallado
- Tiene un diseño moderno con tarjetas interactivas

**Abre primero:** `target/encounter-reports/index.html`

#### 📄 Archivos de Detalle

Los nombres de archivo de detalle se generan automáticamente con el formato:
`{visit_occurrence_id}_{YYYYMMDD_HHmmssSSS}.html`

Esto permite:
- ✅ Identificar fácilmente qué encuentro corresponde a cada reporte
- ✅ Tener múltiples reportes del mismo encuentro sin sobrescribir archivos anteriores
- ✅ Saber exactamente cuándo se generó cada reporte
- ✅ Navegar fácilmente desde el índice a los detalles

## Estructura de los Reportes HTML

### 📋 Archivo Índice (`index.html`)

El archivo índice muestra:
1. **Encabezado con estadísticas**:
   - Total de encuentros consultados
   - Fecha y hora de generación del índice

2. **Tarjetas de encuentros**:
   - Número secuencial
   - Visit Occurrence ID destacado
   - Fecha de consulta del encuentro
   - Nombre del archivo de detalle
   - Botón "Ver Detalle" que abre el reporte completo

3. **Diseño interactivo**:
   - Tarjetas con efecto hover
   - Links funcionales a cada detalle
   - Diseño responsivo para móviles

### 📄 Reportes de Detalle

Cada reporte de detalle incluye:

1. **Encabezado con información general**:
   - Visit Occurrence ID
   - Fecha de consulta
   - Fecha de generación del reporte

2. **Tablas organizadas**:
   - Todas las tablas del response JSON organizadas visualmente
   - Cada tabla muestra sus datos en formato tabular
   - Contador de registros por tabla

3. **Secciones incluidas**:
   - `cab_visit_occurrence`
   - `detail_visit_occurrence`
   - `encounters_sub_status`
   - `my_assign_billing`
   - `return_visit_occurrence`
   - `visit_occurrence_status_history`
   - `return_visit_occurrence_reasons`
   - Y todas las demás tablas del response

## Personalización

### Cambiar tokens de autenticación

Si necesitas usar diferentes tokens, edita el archivo:

```
src/test/java/com/example/steps/EncountersStepDef.java
```

En el método `consultaElEncuentroConVisitOccurrenceId()` encontrarás las variables:
- `authToken` (Authorization Bearer)
- `awsXAuthToken` (aws-x-authorization)
- `awsXSource` (aws-x-source)
- `key` (clave en el body del request)

### Cambiar la URL base

Si necesitas cambiar la URL del endpoint, edita:

```
src/test/java/com/example/steps/EncountersStepDef.java
```

En el método `elUsuarioTieneAccesoAlEndpointDeDebug()` cambia la URL:

```java
theActorInTheSpotlight().whoCan(CallAnApi.at("https://tu-nueva-url.com"));
```

## Ventajas

✅ **Visual**: Los datos se presentan en tablas HTML fáciles de leer
✅ **Automático**: Solo agregas el ID y se genera el reporte automáticamente
✅ **Múltiples encuentros**: Puedes consultar varios encuentros en una sola ejecución
✅ **Índice centralizado**: Un archivo principal lista todos los encuentros con links directos
✅ **Navegación intuitiva**: Desde el índice puedes acceder a cualquier detalle con un clic
✅ **Histórico**: Los reportes quedan guardados para consultas futuras
✅ **Profesional**: Diseño moderno con gradientes y estilos CSS
✅ **Nombres únicos**: Cada archivo tiene timestamp para evitar sobrescrituras

## Ejemplo de uso

```gherkin
Examples:
  | visit_occurrence_id |
  | 128800388           |
  | 128800389           |
  | 128800500           |
  | 129000123           |
```

**Ejecuta:**
```bash
mvn clean test -Dcucumber.filter.tags="@debug001"
```

**Archivos generados automáticamente:**

1. **Índice principal** (se actualiza después de cada encuentro):
   - `index.html` ← Lista todos los encuentros con links funcionales

2. **Archivos de detalle** (uno por cada encuentro):
   - `128800388_20260727_143052123.html`
   - `128800389_20260727_143052456.html`
   - `128800500_20260727_143052789.html`
   - `129000123_20260727_143053012.html`

**Flujo de uso:**
1. ✅ Ejecuta el comando Maven
2. ✅ Espera a que termine (verás mensajes de "Índice actualizado...")
3. ✅ Abre `target/encounter-reports/index.html`
4. ✅ Navega con los botones "Ver Detalle" de cada encuentro

---

**Nota**: Los tokens de autenticación tienen tiempo de expiración. Si recibes errores 401, deberás actualizar los tokens en el código.
