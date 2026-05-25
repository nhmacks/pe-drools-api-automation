package com.example.steps;

import com.example.models.order.ResponseOrder;
import com.example.questions.order.OrderResponse;
import com.example.tasks.DeleteOrder;
import com.example.utils.ApiConfig;

import io.cucumber.java.PendingException;
import io.cucumber.java.en.When;
import io.cucumber.java.en.Then;

import net.serenitybdd.screenplay.rest.abilities.CallAnApi;

import static net.serenitybdd.screenplay.actors.OnStage.theActorInTheSpotlight;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.is;


public class DeleteOrderStepDef extends BaseStepDef {
    ResponseOrder responseOrder;
    
    @When("the client deletes order with id {string}")
    public void the_client_deletes_order_with_id(String id) {
        initializeActor("client");
        theActorInTheSpotlight().attemptsTo(DeleteOrder.withIdAndAccept(id));
    }

    @Then("the deletion response should return the removed order identifier {long}")
    public void the_deletion_response_should_return_the_removed_order_identifier(Long expectedId) {
        responseOrder = extractResponse(new OrderResponse());
        assertThat(responseOrder.getId(), is(expectedId));
    }

    @Then("the deletion response should return the removed pet identifier {long}")
    public void the_deletion_response_should_return_the_removed_pet_identifier(long expectedPetId) {
        assertThat(responseOrder.getPetId(), is(expectedPetId));
    }

    @Then("the deletion response should return the removed order quantity {int}")
    public void the_deletion_response_should_return_the_removed_order_quantity(int expectedQuantity) {
        assertThat(responseOrder.getQuantity(), is(expectedQuantity));
    }

    @Then("the deletion response should return the removed shipping date {string}")
    public void the_deletion_response_should_return_the_removed_shipping_date(String expectedShipDate) {
        assertThat(responseOrder.getShipDate(), containsString(expectedShipDate));
    }

    @Then("the deletion response should return the order status at deletion time {string}")
    public void the_deletion_response_should_return_the_order_status_at_deletion_time(String expectedStatus) {
        assertThat(responseOrder.getStatus(), is(expectedStatus));
    }

    @Then("the deletion response should indicate whether the order was completed {string}")
    public void the_deletion_response_should_indicate_whether_the_order_was_completed(String expectedComplete) {
        assertThat(responseOrder.getComplete(), is(Boolean.parseBoolean(expectedComplete)));
    }

}
