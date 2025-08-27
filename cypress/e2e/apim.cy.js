describe("APIM API Endpoint Test", () => {
  it("Returns 404 JSON from the http_trigger API", () => {
    cy.request({
      url: Cypress.env("APIM_URL"),
      failOnStatusCode: false // prevent Cypress from failing on 404
    }).then((response) => {
      expect(response.status).to.eq(404);
      expect(response.body).to.have.property("statusCode", 404);
      expect(response.body).to.have.property("message", "Resource not found");
    });
  });
});
