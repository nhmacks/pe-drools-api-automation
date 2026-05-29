package com.example.models.encounters.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

/**
 * Represents a service within an encounter.
 * Fields use String types to enable negative testing with invalid data types.
 */
@JsonPropertyOrder({"order_id", "empresa", "sede", "beneficio","producto", "codigo_autorizacion", "codigo_prestacion",  "importe", "cantidad"})
public class Service {

    @JsonProperty("order_id")
    private Integer orderId;

    private String empresa;
    //private String estado;
    private String sede;
    private String producto;
    private String beneficio;

    @JsonProperty("codigo_autorizacion")
    private String codigoAutorizacion;

    @JsonProperty("codigo_prestacion")
    private String codigoPrestacion;

    private Double importe;
    private Integer cantidad;

    public Service() {
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getEmpresa() {
        return empresa;
    }

    public void setEmpresa(String empresa) {
        this.empresa = empresa;
    }

    public String getSede() {
        return sede;
    }

    public void setSede(String sede) {
        this.sede = sede;
    }

    public String getBeneficio() {
        return beneficio;
    }

    public void setBeneficio(String beneficio) {
        this.beneficio = beneficio;
    }

    public String getProducto() {
        return producto;
    }

    public void setProducto(String producto) {
        this.producto = producto;
    }

    public String getCodigoAutorizacion() {
        return codigoAutorizacion;
    }

    public void setCodigoAutorizacion(String codigoAutorizacion) {
        this.codigoAutorizacion = codigoAutorizacion;
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

    public Integer getCantidad() {
        return cantidad;
    }

    public void setCantidad(Integer cantidad) {
        this.cantidad = cantidad;
    }

    @Override
    public String toString() {
        return "Service{" +
                "orderId=" + orderId +
                ", empresa='" + empresa + '\'' +
                ", sede='" + sede + '\'' +
                ", beneficio='" + beneficio + '\'' +
                ", producto='" + producto + '\'' +
                ", codigoAutorizacion='" + codigoAutorizacion + '\'' +
                ", codigoPrestacion='" + codigoPrestacion + '\'' +
                ", importe=" + importe +
                ", cantidad=" + cantidad +
                '}';
    }
}
