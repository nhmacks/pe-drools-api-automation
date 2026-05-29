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
import com.example.tasks.PostEncounters;
import com.example.utils.ApiConfig;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.PendingException;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import net.serenitybdd.screenplay.rest.abilities.CallAnApi;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;

import static net.serenitybdd.screenplay.actors.OnStage.theActorCalled;
import static net.serenitybdd.screenplay.actors.OnStage.theActorInTheSpotlight;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class EncountersStepDef extends BaseStepDef {

    private Encounter currentEncounter;
    private EncountersResponse encountersResponse;

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
        // Quitar el primer carácter del financiador si tiene valor
        String financiador = service.getFinanciador();
        if (financiador != null && financiador.length() > 1 && !"(cualquiera)".equals(financiador)) {
            service.setFinanciador(financiador.substring(1));
            currentEncounter.setFinanciador(financiador.substring(1));
        }
        //Quitar el primer carácter del producto si tiene valor
        String producto = service.getProducto();
        if (producto != null && producto.length() > 1 && !"(cualquiera)".equals(producto)) {
            service.setProducto(producto.substring(1));
        }
        if ("(cualquiera)".equals(service.getFinanciador()) && "(cualquiera)".equals(service.getProducto())) {
            String[] randomRow = getRandomRowFromCsv("Lst_Productos.csv");
            service.setFinanciador(randomRow[0]); // PLAN_PK
            service.setProducto(randomRow[1]);    // CODIGO_GARANTE_PK
            currentEncounter.setFinanciador(randomRow[0]); // Aseguramos que el financiador del encounter coincida con el del servicio
        } else if (!"(cualquiera)".equals(service.getFinanciador()) && "(cualquiera)".equals(service.getProducto())) {
            String[] randomRow = getRandomRowByFinanciadorFromCsv("Lst_Productos.csv", service.getFinanciador());
            service.setProducto(randomRow[1]); // CODIGO_GARANTE_PK
        }
        if("(cualquiera)".equals(service.getBeneficio())) {
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
        service.setEstado(row.get("estado"));
        service.setSede(row.get("sede"));

        String ambito = row.get("ambito");
        if (ambito != null && !ambito.isEmpty()) {
            service.setAmbito(Integer.parseInt(ambito));
        }

        service.setFinanciador(row.get("financiador"));
        service.setProducto(row.get("producto"));
        service.setPlan(row.get("plan"));
        service.setBeneficio(row.getOrDefault("beneficio", ""));
        service.setCodigoAutorizacion(row.get("codigo_autorizacion"));
        service.setTipoEncounter(row.get("tipo_encounter"));
        service.setCodigoPrestacion(row.get("codigo_prestacion"));

        String importe = row.get("importe");
        if (importe != null && !importe.isEmpty()) {
            service.setImporte(Double.parseDouble(importe));
        }

        String cantidad = row.get("cantidad");
        if (cantidad != null && !cantidad.isEmpty()) {
            service.setCantidad(Integer.parseInt(cantidad));
        }

        String departamento = row.get("departamento");
        String provincia = row.get("provincia");
        if (departamento != null || provincia != null) {
            Ubicacion ubicacion = new Ubicacion(departamento, provincia);
            service.setUbicacion(ubicacion);
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
        List<String> expectedDocumentos = List.of(documentos.split(",\\s*"));
        assertThat(encounter.getDocumentosNecesarios(), containsInAnyOrder(expectedDocumentos.toArray()));
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
                if (columns.length >= 2) {
                    rows.add(new String[]{columns[0].trim(), columns[1].trim()});
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
                if (columns.length >= 2 && financiador.equals(columns[0].trim())) {
                    matchingRows.add(new String[]{columns[0].trim(), columns[1].trim()});
                }
            }
        } catch (IOException | NullPointerException e) {
            throw new RuntimeException("Error al leer el archivo CSV: " + filePath, e);
        }

        if (matchingRows.isEmpty()) {
            throw new AssertionError("No se encontraron productos para el financiador '" + financiador +
                    "' en el archivo CSV: " + filePath +
                    ". Verifique que el valor del financiador exista en la columna PLAN_PK del archivo.");
        }

        Random random = new Random();
        return matchingRows.get(random.nextInt(matchingRows.size()));
    }
}
