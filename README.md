☁️ Cloud Infrastructure as Code (Terraform)

This repository contains production-grade Infrastructure as Code (IaC) built with Terraform to provision, manage, and test cloud environments on Microsoft Azure. It follows modern DevOps practices including modular design, CI/CD automation, linting, and automated integration tests.

🚀 What This Project Does

    Infrastructure as Code (IaC): Deploys full Azure environments (test + production) using Terraform.

    Environment Isolation: Separate configurations for test and prod under terraform/environments/.

    Modular Design: Reusable Terraform modules (backend, frontend) for scalable and maintainable code.

    Automated Pipelines: GitHub Actions workflows run:

        🔍 terraform fmt, terraform validate, and TFLint

        🧪 Spin up test environments automatically on Pull Requests

        ✅ Run Cypress end-to-end tests against deployed infrastructure

        🚀 Promote to production only if tests succeed

        🧹 Destroy test environments after merge to keep costs low

🛠️ Technologies & Tools

    Terraform (IaC)

    Azure Resource Manager (AzureRM provider)

    GitHub Actions (CI/CD pipelines)

    Cypress (end-to-end infrastructure tests)

    TFLint (Terraform linting & best practices)

    Azure CLI & OIDC authentication (secure GitHub → Azure deployment without secrets)

🔄 GitHub Actions CI/CD Flow

    Pull Request Opened →

        Lint Terraform (fmt, validate, tflint)

        Deploy PR-specific test infrastructure

        Run Cypress E2E tests against deployed endpoints

    Merge to main →

        If tests pass, deploys to Production

        Runs Cypress tests in prod

        Destroys test environment to reduce costs

✨ Why This Project Stands Out

    ✅ Enterprise-ready IaC: Modular, versioned, and environment-aware

    ✅ Full DevOps Automation: From lint → deploy → test → promote → cleanup

    ✅ Secure Deployments: Uses GitHub OIDC for passwordless, short-lived Azure tokens

    ✅ Cost-efficient: Auto-destroys ephemeral test environments

    ✅ Demonstrates Cloud Engineering Skills across Terraform, Azure, CI/CD, and automated testing

This project was built to demonstrate cloud engineering excellence—covering automation, scalability, testing, and security in Azure with Terraform and modern CI/CD practices.