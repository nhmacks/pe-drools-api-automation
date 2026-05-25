package com.example.models.encounters.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class ServiceResponse {

    @JsonProperty("order_id")
    private Integer orderId;

    @JsonProperty("codigo_prestacion")
    private String codigoPrestacion;

    private Double importe;

    @JsonProperty("documentos_necesarios")
    private List<Object> documentosNecesarios;

    @JsonProperty("documentos_reemplazables")
    private List<Object> documentosReemplazables;

    public ServiceResponse() {
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getCodigoPrestacion() {
        return codigoPrestacion;
    }

    public void setCodigoPrestacion(String codigoPrestacion) {
        this.codigoPrestacion = codigoPrestacion;
    }

    public Double getImporte() {
        return importe;
    }

    public void setImporte(Double importe) {
        this.importe = importe;
    }

    public List<Object> getDocumentosNecesarios() {
        return documentosNecesarios;
    }

    public void setDocumentosNecesarios(List<Object> documentosNecesarios) {
        this.documentosNecesarios = documentosNecesarios;
    }

    public List<Object> getDocumentosReemplazables() {
        return documentosReemplazables;
    }

    public void setDocumentosReemplazables(List<Object> documentosReemplazables) {
        this.documentosReemplazables = documentosReemplazables;
    }
}
