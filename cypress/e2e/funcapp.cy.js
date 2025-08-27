describe("Function App Root URL Test", () => {
  it("Displays the default Functions welcome page", () => {
    cy.visit(Cypress.env("FUNCAPP_URL"));
    cy.contains("Your Functions 4.0 app is up and running").should("be.visible");
  });
});
