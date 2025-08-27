describe("Front Door Endpoint Test", () => {
  it("Loads the Front Door endpoint and shows expected 404 message", () => {
    cy.visit("/", { failOnStatusCode: false }); // ✅ allow 404
    cy.contains("The requested content does not exist.").should("be.visible");
    cy.contains("HttpStatusCode: 404").should("be.visible");
    cy.contains("ErrorCode: WebContentNotFound").should("be.visible");
  });
});