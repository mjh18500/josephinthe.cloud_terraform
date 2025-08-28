describe("CosmosDB Table Endpoint Test", () => {
  it("Returns 400 Status: odata.error: Request URL is invalid", () => {
    cy.request({
      url: Cypress.env("COSMOSDB_URL"),
      failOnStatusCode: false // prevent Cypress from failing on 404
    }).then((response) => {
      expect(response.status).to.eq(400);
      const body = response.body;
      expect(body).to.have.property('odata.error');
      expect(body['odata.error']).to.have.property('code', 'InvalidInput');
      expect(body['odata.error'].message).to.have.property('lang', 'en-us');
      expect(body['odata.error'].message.value).to.include('Request url is invalid.');
    });
  });
});