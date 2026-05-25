package com.example.steps;

import com.example.models.order.get.response.ErrorResponseOrder;
import com.example.questions.order.OrderErrorResponse;
import com.example.tasks.GetOrder;
import com.example.questions.order.OrderResponse;
import com.example.models.order.ResponseOrder;
import com.example.utils.ApiConfig;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;
import io.cucumber.java.en.Then;

import net.serenitybdd.screenplay.rest.abilities.CallAnApi;

import static net.serenitybdd.screenplay.actors.OnStage.theActorCalled;
import static net.serenitybdd.screenplay.actors.OnStage.theActorInTheSpotlight;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class GetOrderStepDef extends BaseStepDef {

    ResponseOrder responseOrder;
    ErrorResponseOrder errorResponseOrder;

    @Given("the order does not exist with id {string}")
    public void the_order_does_not_exist_with_id(String id) {
        theActorCalled("client");
    }
    @When("the client requests order with id {string}")
    public void the_client_requests_order_with_id_and_accept(String id) {
        initializeActor("client");
        theActorInTheSpotlight().attemptsTo(GetOrder.withIdAndAccept(id));
    }

    @Then("the response should include the order identifier {int}")
    public void the_response_should_include_the_order_identifier(Integer expectedId) {
        this.responseOrder = extractResponse(new OrderResponse());
        assertThat(responseOrder.getId(), is(expectedId.longValue()));
    }

    @And("the response should include the associated pet identifier {int}")
    public void the_response_should_include_the_associated_pet_identifier(Integer expectedPetId) {
        assertThat(responseOrder.getPetId(), is(expectedPetId.longValue()));
    }

    @And("the response should include the ordered quantity {int}")
    public void the_response_should_include_the_ordered_quantity(Integer expectedQuantity) {
        assertThat(responseOrder.getQuantity(), is(expectedQuantity));
    }

    @And("the response should include the shipping date {string}")
    public void the_response_should_include_the_shipping_date(String expectedShipDate) {
        assertThat(responseOrder.getShipDate(), is(expectedShipDate));
    }
    @And("the response should include the order status {string}")
    public void the_response_should_include_the_order_status(String expectedStatus) {
        assertThat(responseOrder.getStatus(), is(expectedStatus));
    }
    @And ("the response should indicate whether the order is completed {string}")
    public void the_response_should_indicate_whether_the_order_is_completed(String expectedComplete) {
        Boolean expectedCompleteBool = Boolean.parseBoolean(expectedComplete);
        assertThat(responseOrder.getComplete(), is(expectedCompleteBool));
    }

    @And("the response should indicate order not found")
    public void theResponseShouldIndicateOrderNotFound() {
        errorResponseOrder = extractResponse(new OrderErrorResponse().asErrorResponseOrder());
        assertThat(errorResponseOrder.getCode(),equalTo(1));
        assertThat(errorResponseOrder.getType(),equalTo("error"));
        assertThat(errorResponseOrder.getMessage(), containsString("Order not found"));
    }

    @And("the response should indicate order not found 404")
    public void theResponseShouldIndicateOrderNotFound404() {
        errorResponseOrder = extractResponse(new OrderErrorResponse().asErrorResponseOrder());
        assertThat(errorResponseOrder.getCode(),equalTo(404));
        assertThat(errorResponseOrder.getType(),equalTo("unknown"));
        assertThat(errorResponseOrder.getMessage(), containsString("Order Not Found"));
    }
}

