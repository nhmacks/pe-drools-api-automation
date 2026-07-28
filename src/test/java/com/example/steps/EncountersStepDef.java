package com.example.steps;

import com.example.models.encounters.request.Encounter;
import com.example.models.encounters.request.EncountersRequest;
import com.example.models.encounters.request.Service;
import com.example.models.encounters.request.Ubicacion;
import com.example.models.encounters.response.EncounterResponse;
import com.example.models.encounters.response.EncountersResponse;
import com.example.models.encounters.response.ServiceResponse;
import com.example.questions.common.ResponseStatusCode;
import com.example.questions.encounters.EncountersFullResponse;
import com.example.questions.encounters.EncounterDebugDetailResponse;
import com.example.tasks.PostEncounters;
import com.example.tasks.GetEncounterDebugDetail;
import com.example.utils.ApiConfig;
import com.example.utils.HtmlReportGenerator;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.PendingException;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import net.serenitybdd.screenplay.rest.abilities.CallAnApi;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import static net.serenitybdd.screenplay.actors.OnStage.theActorCalled;
import static net.serenitybdd.screenplay.actors.OnStage.theActorInTheSpotlight;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class EncountersStepDef extends BaseStepDef {

    private static List<Map<String, String>> encounteredReports = new ArrayList<>();
    private static Map<String, Map<String, Object>> responseDataCache = new HashMap<>();
    private static boolean alreadyCleared = false;

    private Encounter currentEncounter;
    private EncountersResponse encountersResponse;
    private Map<String, Object> debugDetailResponse;
    private String currentVisitOccurrenceId;
    private String currentReportFileName;

    private void initializeActorForEncounters(String actorName) {
        theActorCalled(actorName);
        theActorInTheSpotlight().whoCan(CallAnApi.at(ApiConfig.encountersBaseUrl()));
    }

    @When("el {string} envia un encounter con los siguientes datos:")
    public void elClienteEnviaUnEncounterConLosSiguientesDatos(String actorName, DataTable table) {
        initializeActorForEncounters(actorName);
        Map<String, String> row = table.asMaps().get(0);
        currentEncounter = buildEncounterFromRow(row);
        currentEncounter.setServices(new ArrayList<>());
    }

    @And("contiene el siguiente servicio:")
    public void contieneElSiguienteServicio(DataTable table) {
        Map<String, String> row = table.asMaps().get(0);
        Service service = buildServiceFromRow(row);
        // Quitar el primer carácter del financiador si tiene valor (excepto valores especiales)
        String financiador = currentEncounter.getFinanciador();
        if (financiador != null && financiador.length() > 1
                && !"(cualquiera)".equals(financiador)
                && !financiador.startsWith("!=")) {
            currentEncounter.setFinanciador(financiador.substring(1));
        }
        //Quitar el primer carácter del producto si tiene valor
        String producto = service.getProducto();
        if (producto != null && producto.length() > 1 && !"(cualquiera)".equals(producto)) {
            service.setProducto(producto.substring(1));
        }
        // Manejar financiador con exclusión (!= X)
        if (currentEncounter.getFinanciador() != null && currentEncounter.getFinanciador().startsWith("!=")) {
            String excludedValue = currentEncounter.getFinanciador().substring(2).trim();
            String[] randomRow = getRandomRowExcludingFinanciador("Lst_Productos.csv", excludedValue);
            currentEncounter.setFinanciador(randomRow[0]); // CODIGO_GARANTE_PK (financiador)
            if ("(cualquiera)".equals(service.getProducto())) {
                service.setProducto(randomRow[1]); // PLAN_PK (producto)
            }
            System.out.println("Financiador seleccionado (excluyendo " + excludedValue + "): " + randomRow[0]);
        } else if ("(cualquiera)".equals(currentEncounter.getFinanciador()) && "(cualquiera)".equals(service.getProducto())) {
            String[] randomRow = getRandomRowFromCsv("Lst_Productos.csv");
            currentEncounter.setFinanciador(randomRow[0]); // CODIGO_GARANTE_PK (financiador)
            service.setProducto(randomRow[1]);             // PLAN_PK (producto)
        } else if (!"(cualquiera)".equals(currentEncounter.getFinanciador()) && "(cualquiera)".equals(service.getProducto())) {
            String[] randomRow = getRandomRowByFinanciadorFromCsv("Lst_Productos.csv", currentEncounter.getFinanciador());
            System.out.println("Financiador: " + currentEncounter.getFinanciador() + ". Producto seleccionado: " + randomRow[1]);
            service.setProducto(randomRow[1]); // PLAN_PK (producto)
        }
        if ("(cualquiera)".equals(service.getBeneficio())) {
            String[] randomRow = getRandomRowFromCsv("Lst_Beneficio2.csv");
            service.setBeneficio(randomRow[0]); // BENEFICIO_PK
        }
        currentEncounter.getServices().add(service);
    }

    @Then("el estado de respuesta debe ser {int}")
    public void elEstadoDeRespuestaDebeSer(Integer expectedStatus) {
        Integer actualStatus = extractResponse(ResponseStatusCode.status());
        assertThat(actualStatus, is(expectedStatus));
    }

    @And("la respuesta contiene el encounter_id {string}")
    public void laRespuestaContieneElEncounterId(String expectedEncounterId) {
        encountersResponse = extractResponse(EncountersFullResponse.received());
        assertThat(encountersResponse.getEncounters(), is(not(empty())));
        EncounterResponse encounter = encountersResponse.getEncounters().get(0);
        assertThat(encounter.getEncounterId(), is(expectedEncounterId));
    }

    @And("el encounter tiene {int} servicio")
    public void elEncounterTieneServicios(Integer expectedCount) {
        if (encountersResponse == null) {
            encountersResponse = extractResponse(EncountersFullResponse.received());
        }
        EncounterResponse encounter = encountersResponse.getEncounters().get(0);
        assertThat(encounter.getServices(), hasSize(expectedCount));
    }

    @And("el servicio {int} en la respuesta tiene order_id {int}")
    public void elServicioEnLaRespuestaTieneOrderId(Integer serviceIndex, Integer expectedOrderId) {
        if (encountersResponse == null) {
            encountersResponse = extractResponse(EncountersFullResponse.received());
        }
        ServiceResponse service = encountersResponse.getEncounters().get(0).getServices().get(serviceIndex - 1);
        assertThat(service.getOrderId(), is(expectedOrderId));
    }

    @And("el servicio {int} en la respuesta tiene codigo_prestacion {string}")
    public void elServicioEnLaRespuestaTieneCodigoPrestacion(Integer serviceIndex, String expectedCodigo) {
        if (encountersResponse == null) {
            encountersResponse = extractResponse(EncountersFullResponse.received());
        }
        ServiceResponse service = encountersResponse.getEncounters().get(0).getServices().get(serviceIndex - 1);
        assertThat(service.getCodigoPrestacion(), is(expectedCodigo));
    }

    @And("el servicio {int} en la respuesta tiene importe {double}")
    public void elServicioEnLaRespuestaTieneImporte(Integer serviceIndex, Double expectedImporte) {
        if (encountersResponse == null) {
            encountersResponse = extractResponse(EncountersFullResponse.received());
        }
        ServiceResponse service = encountersResponse.getEncounters().get(0).getServices().get(serviceIndex - 1);
        assertThat(service.getImporte(), is(closeTo(expectedImporte, 0.01)));
    }

    @And("el encounter tiene {int} documentos necesarios")
    public void elEncounterTieneDocumentosNecesarios(Integer expectedCount) {
        if (encountersResponse == null) {
            encountersResponse = extractResponse(EncountersFullResponse.received());
        }
        EncounterResponse encounter = encountersResponse.getEncounters().get(0);
        assertThat(encounter.getDocumentosNecesarios(), hasSize(expectedCount));
    }

    @And("el encounter tiene {int} documentos reemplazables")
    public void elEncounterTieneDocumentosReemplazables(Integer expectedCount) {
        if (encountersResponse == null) {
            encountersResponse = extractResponse(EncountersFullResponse.received());
        }
        EncounterResponse encounter = encountersResponse.getEncounters().get(0);
        assertThat(encounter.getDocumentosReemplazables(), hasSize(expectedCount));
    }

    @And("el servicio {int} tiene {int} documentos necesarios")
    public void elServicioTieneDocumentosNecesarios(Integer serviceIndex, Integer expectedCount) {
        if (encountersResponse == null) {
            encountersResponse = extractResponse(EncountersFullResponse.received());
        }
        ServiceResponse service = encountersResponse.getEncounters().get(0).getServices().get(serviceIndex - 1);
        assertThat(service.getDocumentosNecesarios(), hasSize(expectedCount));
    }

    @And("el servicio {int} tiene {int} documentos reemplazables")
    public void elServicioTieneDocumentosReemplazables(Integer serviceIndex, Integer expectedCount) {
        if (encountersResponse == null) {
            encountersResponse = extractResponse(EncountersFullResponse.received());
        }
        ServiceResponse service = encountersResponse.getEncounters().get(0).getServices().get(serviceIndex - 1);
        assertThat(service.getDocumentosReemplazables(), hasSize(expectedCount));
    }

    private Encounter buildEncounterFromRow(Map<String, String> row) {
        Encounter encounter = new Encounter();
        encounter.setEncounterId(row.get("encounter_id"));
        encounter.setFinanciador(row.get("financiador"));
        encounter.setTipoEncounter(row.get("tipo_encounter"));
        encounter.setEmpresa(row.getOrDefault("empresa", ""));
        encounter.setSede(row.getOrDefault("sede", ""));

        String importeTotal = row.get("importe_total");
        if (importeTotal != null && !importeTotal.isEmpty()) {
            encounter.setImporteTotal(Double.parseDouble(importeTotal));
        }

        return encounter;
    }

    private Service buildServiceFromRow(Map<String, String> row) {
        Service service = new Service();

        String orderId = row.get("order_id");
        if (orderId != null && !orderId.isEmpty()) {
            service.setOrderId(Integer.parseInt(orderId));
        }

        service.setEmpresa(row.getOrDefault("empresa", ""));
        service.setSede(row.get("sede"));

        service.setProducto(row.get("producto"));
        service.setBeneficio(row.getOrDefault("beneficio", ""));
        service.setCodigoAutorizacion(row.get("codigo_autorizacion"));
        service.setCodigoPrestacion(row.get("codigo_prestacion"));

        String importe = row.get("importe");
        if (importe != null && !importe.isEmpty()) {
            service.setImporte(Double.parseDouble(importe));
        }

        String cantidad = row.get("cantidad");
        if (cantidad != null && !cantidad.isEmpty()) {
            service.setCantidad(Integer.parseInt(cantidad));
        }

        return service;
    }

    @And("envia la solicitud al endpoint de encounters")
    public void enviaLaSolicitudAlEndpointDeEncounters() {
        EncountersRequest request = new EncountersRequest(List.of(currentEncounter));
        theActorInTheSpotlight().attemptsTo(PostEncounters.withDetails(request));
    }

    @And("el encuentro indica como documentos necesario {string}")
    public void elEncuentroIndicaComoDocumentosNecesario(String documentos) {
        EncounterResponse encounter = encountersResponse.getEncounters().get(0);
        if (documentos == null || documentos.trim().isEmpty()) {
            assertThat(encounter.getDocumentosNecesarios(), is(empty()));
        } else {
            List<String> expectedDocumentos = List.of(documentos.split(",\\s*"));
            List<String> actualDocumentos = parseDocumentos(encounter.getDocumentosNecesarios());
            assertThat(actualDocumentos, containsInAnyOrder(expectedDocumentos.toArray()));
        }
    }

    @And("el servicio {int} indica documentos necesarios {string}")
    public void elServicioIndicaDocumentosNecesarios(Integer serviceIndex, String documentos) {
        ServiceResponse service = encountersResponse.getEncounters().get(0).getServices().get(serviceIndex - 1);
        if (documentos == null || documentos.trim().isEmpty()) {
            assertThat(service.getDocumentosNecesarios(), is(empty()));
        } else {
            List<String> expectedDocumentos = List.of(documentos.split(",\\s*"));
            List<String> actualDocumentos = parseDocumentos(service.getDocumentosNecesarios());
            assertThat(actualDocumentos, containsInAnyOrder(expectedDocumentos.toArray()));
        }
    }

    @And("el encuentro indica como documentos reemplazables {string}")
    public void elEncuentroIndicaComoDocumentosReemplazables(String documentos) {
        EncounterResponse encounter = encountersResponse.getEncounters().get(0);
        if (documentos == null || documentos.trim().isEmpty()) {
            assertThat(encounter.getDocumentosReemplazables(), is(empty()));
        } else {
            List<String> expectedDocumentos = List.of(documentos.split(",\\s*"));
            List<String> actualDocumentos = parseDocumentos(encounter.getDocumentosReemplazables());
            assertThat(actualDocumentos, containsInAnyOrder(expectedDocumentos.toArray()));
        }
    }

    private List<String> parseDocumentos(List<Object> documentos) {
        List<String> result = new ArrayList<>();
        for (Object doc : documentos) {
            String str = doc.toString();
            // Si el elemento es un String con formato de lista "[002, 010]", extraer los valores
            if (str.startsWith("[") && str.endsWith("]")) {
                String content = str.substring(1, str.length() - 1);
                if (!content.trim().isEmpty()) {
                    for (String item : content.split(",\\s*")) {
                        result.add(item.trim());
                    }
                }
            } else {
                result.add(str);
            }
        }
        return result;
    }

    private String[] getRandomRowFromCsv(String fileName) {
        List<String[]> rows = new ArrayList<>();
        String filePath = "data/" + fileName;

        try (InputStream inputStream = getClass().getClassLoader().getResourceAsStream(filePath);
             BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))) {

            String line;
            boolean isHeader = true;
            while ((line = reader.readLine()) != null) {
                if (isHeader) {
                    isHeader = false;
                    continue;
                }
                String[] columns = line.split(",");
                // columns[0] = PLAN_PK (producto), columns[1] = CODIGO_GARANTE_PK (financiador)
                if (columns.length >= 2) {
                    rows.add(new String[]{columns[1].trim(), columns[0].trim()}); // {financiador, producto}
                }
            }
        } catch (IOException | NullPointerException e) {
            throw new RuntimeException("Error al leer el archivo CSV: " + filePath, e);
        }

        if (rows.isEmpty()) {
            throw new RuntimeException("No se encontraron filas en el archivo CSV: " + filePath);
        }

        Random random = new Random();
        return rows.get(random.nextInt(rows.size()));
    }

    private String[] getRandomRowByFinanciadorFromCsv(String fileName, String financiador) {
        List<String[]> matchingRows = new ArrayList<>();
        String filePath = "data/" + fileName;

        try (InputStream inputStream = getClass().getClassLoader().getResourceAsStream(filePath);
             BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))) {

            String line;
            boolean isHeader = true;
            while ((line = reader.readLine()) != null) {
                if (isHeader) {
                    isHeader = false;
                    continue;
                }
                String[] columns = line.split(",");
                // columns[0] = PLAN_PK (producto), columns[1] = CODIGO_GARANTE_PK (financiador)
                if (columns.length >= 2 && financiador.equals(columns[1].trim())) {
                    matchingRows.add(new String[]{columns[1].trim(), columns[0].trim()}); // {financiador, producto}
                }
            }
        } catch (IOException | NullPointerException e) {
            throw new RuntimeException("Error al leer el archivo CSV: " + filePath, e);
        }

        if (matchingRows.isEmpty()) {
            throw new AssertionError("No se encontraron productos para el financiador '" + financiador +
                    "' en el archivo CSV: " + filePath +
                    ". Verifique que el valor del financiador exista en la columna CODIGO_GARANTE_PK del archivo.");
        }

        Random random = new Random();
        return matchingRows.get(random.nextInt(matchingRows.size()));
    }

    private String[] getRandomRowExcludingFinanciador(String fileName, String excludedFinanciador) {
        List<String[]> matchingRows = new ArrayList<>();
        String filePath = "data/" + fileName;

        try (InputStream inputStream = getClass().getClassLoader().getResourceAsStream(filePath);
             BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))) {

            String line;
            boolean isHeader = true;
            while ((line = reader.readLine()) != null) {
                if (isHeader) {
                    isHeader = false;
                    continue;
                }
                String[] columns = line.split(",");
                // columns[0] = PLAN_PK (producto), columns[1] = CODIGO_GARANTE_PK (financiador)
                // Excluir el financiador especificado
                if (columns.length >= 2 && !excludedFinanciador.equals(columns[1].trim())) {
                    matchingRows.add(new String[]{columns[1].trim(), columns[0].trim()}); // {financiador, producto}
                }
            }
        } catch (IOException | NullPointerException e) {
            throw new RuntimeException("Error al leer el archivo CSV: " + filePath, e);
        }

        if (matchingRows.isEmpty()) {
            throw new AssertionError("No se encontraron productos excluyendo el financiador '" + excludedFinanciador +
                    "' en el archivo CSV: " + filePath);
        }

        Random random = new Random();
        return matchingRows.get(random.nextInt(matchingRows.size()));
    }

    @Given("el usuario tiene acceso al endpoint de debug")
    public void elUsuarioTieneAccesoAlEndpointDeDebug() {
        theActorCalled("usuario");
        theActorInTheSpotlight().whoCan(CallAnApi.at("https://ownci9p16m.execute-api.us-east-1.amazonaws.com"));
    }

    @When("consulta el encuentro con visit_occurrence_id {string}")
    public void consultaElEncuentroConVisitOccurrenceId(String visitOccurrenceId) {
        currentVisitOccurrenceId = visitOccurrenceId;

        String authToken = "eyJraWQiOiJhNUhVdnhYTHBQY2V4blIyakR1NTNuZ1h4bkJIWVdZVjBhU0g2Y3Z2eDRJPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJjYzA4ODFhNy02YjQ1LTQ0NjQtOWI0NC04NWYwNzIxZGNkYWEiLCJjb2duaXRvOmdyb3VwcyI6WyJudXJzaW5nIiwiaW5zdXJhbmNlLWJpbGxpbmc6Z2VzdG9yLXRhIl0sImlzcyI6Imh0dHBzOi8vY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb20vdXMtZWFzdC0xX1VtNEJ6dm5oMSIsImNsaWVudF9pZCI6IjNmM2N1OXRrYzdxamE4ZTRvYXJyNXZlYm40Iiwib3JpZ2luX2p0aSI6ImZhY2NhOTA4LTc4ZTYtNDczNC05ZTU3LTRiZjVlMTcwNDcyZCIsImV2ZW50X2lkIjoiZGJhYzg0OTQtMTUxZC00OTE0LTg0NzItNTBjZmJjOWYyOTdiIiwidG9rZW5fdXNlIjoiYWNjZXNzIiwic2NvcGUiOiJhd3MuY29nbml0by5zaWduaW4udXNlci5hZG1pbiIsImF1dGhfdGltZSI6MTc4NTIxMjc0MiwiZXhwIjoxNzg1MjE2MzQyLCJpYXQiOjE3ODUyMTI3NDIsImp0aSI6IjAzYzIzNzJlLTNlNTctNDkxNS05Nzk4LWQ4NzRhZThmOWNjZCIsInVzZXJuYW1lIjoiZnNhbGNlZG8ifQ.kj1ooC9R_0qH2nT6BFlWoqr1kbjqatb__jI5izfy0mKe0OsQ1H_OTisr6MkgRN7QaUoyoINSJlyqtwHFDjmPn1IHMdQoSfjc81tSkVdYHPaQiZ_lXPsAjPHxeS0jzXnPLrKQxW07kdZIYS0bUDgzlphFBZXkKmTSm8WREBI_f7EHGp7vXqslZZAI3XiP-7UxmnsoPrHRNzgmxLpOLjC-vcqs00b6fvmrsbZ9dJjiLKUNFLCQcp1uB_FibwLjmy773vQNFDICmiQHPezbT0p4W_JTV1Ih3Bj5eyqt5lxHYLL9B24qfHjMRNGEozwb14kAOU5TRt7sRGustnuE_Cgszw";
        String awsXAuthToken = "eyJraWQiOiI5L1BDTGVzMnNFZ3Y0WTRwMUt3ZlplMitkVVJkQ002ZGthM3U1aFA2WEY0PSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJjYzA4ODFhNy02YjQ1LTQ0NjQtOWI0NC04NWYwNzIxZGNkYWEiLCJjdXN0b206aWRfbWF0cml4IjoiaWRfbWF0cml4XzIiLCJjb2duaXRvOmdyb3VwcyI6WyJudXJzaW5nIiwiaW5zdXJhbmNlLWJpbGxpbmc6Z2VzdG9yLXRhIl0sImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiaXNzIjoiaHR0cHM6Ly9jb2duaXRvLWlkcC51cy1lYXN0LTEuYW1hem9uYXdzLmNvbS91cy1lYXN0LTFfVW00Qnp2bmgxIiwiY29nbml0bzp1c2VybmFtZSI6ImZzYWxjZWRvIiwib3JpZ2luX2p0aSI6ImZhY2NhOTA4LTc4ZTYtNDczNC05ZTU3LTRiZjVlMTcwNDcyZCIsImF1ZCI6IjNmM2N1OXRrYzdxamE4ZTRvYXJyNXZlYm40IiwiZXZlbnRfaWQiOiJkYmFjODQ5NC0xNTFkLTQ5MTQtODQ3Mi01MGNmYmM5ZjI5N2IiLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTc4NTIxMjc0MiwibmFtZSI6ImZyYW5jbyIsImV4cCI6MTc4NTIxNjM0MiwiaWF0IjoxNzg1MjEyNzQyLCJmYW1pbHlfbmFtZSI6InNhbGNlZG8iLCJqdGkiOiI3MWQ4OTYyYi0xYzMzLTRhMjctODI3MC0wYTdiZGU3ODM3YzAiLCJlbWFpbCI6ImZyYW5jby5zYWxjZWRvQGV4dGVybm8uYXVuYS5vcmcifQ.HlX1ArVnd19Ik71RDaW1f74rpZEZRi5XKYD4-rs9_YZ6aqWAriH5v989H0J4-Q2-NEOLyBqdjNf8BSF3xNSS8pIdesMuugwtsVOfhTj2GYqL9sJf0w1XfOKGhKa4m4lhBrQVsTdQlQIGU-h6LvXNz5TCscx7Yf5hUOXrbUt2k_qen9ITsFAwYQvVh_BDTZ6x8g1zEgP00p3qSkN3micVTI3bBuxi8FJPNuYYrkxZMck8q7l154W_P_q1ae1wkRTIgsCDE-JoOIqyBSSQJU-zdNu0H9t3GDFzBwBaPHmdR33u7ZfNOVaZxwzmX9guyLNfAuVRnuw6FOQchuy7tLy1UQ";
        String awsXSource = "app-toyota";
        String key = "993af8d118a4d7b94d75c53d0858233ab0b78006a92bfd6a";

        theActorInTheSpotlight().attemptsTo(
            GetEncounterDebugDetail.withId(visitOccurrenceId, authToken, awsXAuthToken, awsXSource, key)
        );

        debugDetailResponse = extractResponse(EncounterDebugDetailResponse.received());
    }

    @And("se genera un reporte HTML")
    public void seGeneraUnReporteHTML() {
        if (debugDetailResponse != null) {
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmssSSS"));
            currentReportFileName = currentVisitOccurrenceId + "_" + timestamp + ".html";

            // Guardar el response data en caché para regeneración posterior
            responseDataCache.put(currentReportFileName, debugDetailResponse);

            HtmlReportGenerator.generateHtmlReport(debugDetailResponse, currentReportFileName);

            Map<String, String> reportInfo = new HashMap<>();
            reportInfo.put("visitOccurrenceId", currentVisitOccurrenceId);
            reportInfo.put("fileName", currentReportFileName);
            reportInfo.put("timestamp", timestamp);
            reportInfo.put("queriedAt", (String) debugDetailResponse.get("queriedAt"));

            encounteredReports.add(reportInfo);

            System.out.println("Reporte HTML generado: " + currentReportFileName);
        } else {
            throw new RuntimeException("No se pudo generar el reporte HTML porque no hay response data disponible");
        }
    }

    public static Map<String, Map<String, Object>> getResponseDataCache() {
        return responseDataCache;
    }

    public static List<Map<String, String>> getEncounteredReports() {
        return encounteredReports;
    }

    public static void clearEncounteredReports() {
        encounteredReports.clear();
        responseDataCache.clear();
    }

    @Given("se limpian los reportes anteriores")
    public void seLimpianLosReportesAnteriores() {
        clearEncounteredReports();
        alreadyCleared = false;
        System.out.println("Lista de encuentros limpiada - Iniciando nueva ejecución");
    }

    @Given("se limpian los reportes anteriores si es el primer encuentro")
    public void seLimpianLosReportesAnterioresSiEsElPrimerEncuentro() {
        if (!alreadyCleared) {
            clearEncounteredReports();
            alreadyCleared = true;
            System.out.println("✨ Lista de encuentros limpiada - Iniciando nueva ejecución");
        }
    }

    @Then("se genera el índice HTML con todos los encuentros consultados")
    public void seGeneraElIndiceHTMLConTodosLosEncuentrosConsultados() {
        List<Map<String, String>> reports = getEncounteredReports();

        System.out.println("\n========================================");
        System.out.println("🔍 GENERANDO ÍNDICE HTML");
        System.out.println("========================================");
        System.out.println("Total de encuentros acumulados: " + reports.size());

        if (reports.isEmpty()) {
            System.out.println("⚠️ ERROR: No hay encuentros para generar el índice");
            System.out.println("⚠️ Asegúrate de ejecutar con: mvn clean test -Dcucumber.filter.tags=\"@debug-encounters\"");
            System.out.println("========================================\n");
            return;
        }

        // Mostrar lista de encuentros
        System.out.println("\nEncuentros a incluir en el índice:");
        for (int i = 0; i < reports.size(); i++) {
            Map<String, String> report = reports.get(i);
            System.out.println("  " + (i + 1) + ". Visit ID: " + report.get("visitOccurrenceId") +
                             " | Archivo: " + report.get("fileName"));
        }

        HtmlReportGenerator.generateIndexReport(reports);
        System.out.println("\n✅ Índice HTML generado exitosamente");
        System.out.println("📂 Ubicación: target/encounter-reports/index.html");
        System.out.println("========================================\n");
    }
}
