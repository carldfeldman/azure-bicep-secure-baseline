Azure Secure Monitoring & Sentinel Baseline (Bicep + CI/CD)
Overview

This repository implements a production-ready Azure security monitoring baseline using Infrastructure as Code (Bicep) and GitHub Actions CI/CD.

The project provisions a Log Analytics Workspace, onboards Microsoft Sentinel programmatically, and deploys Sentinel analytics rules as code, demonstrating a real-world, cost-aware SIEM baseline suitable for enterprise environments.

All deployments are automated, repeatable, and validated using what-if before apply.

Architecture

Core components deployed via Bicep:

Log Analytics Workspace (resource-group scope)

Microsoft Sentinel onboarding using Microsoft.SecurityInsights/onboardingStates

Sentinel analytics rules deployed as ARM child resources

Optional feature toggles to control cost and complexity

Delivery pipeline:

GitHub Actions CI/CD

Azure OIDC authentication (no secrets stored)

Bicep validation + what-if

Idempotent deployment to Azure

Microsoft Sentinel – Detections as Code

This project demonstrates Sentinel analytics rules managed entirely as code, rather than manually in the portal.

Baseline Rule (Safe for New Workspaces)

AzureActivity: Sensitive changes

Detects privileged operations such as:

Role assignments

Policy changes

Key Vault modifications

Designed to deploy cleanly in new environments

Advanced Rules (Source-Dependent, Optional)

These rules are deployed only when explicitly enabled:

Multiple sign-in failures from the same IP

New user added to privileged Entra ID roles

Suspicious PowerShell execution

Advanced rules are gated behind parameters to avoid failed deployments when required data sources are not yet connected.

Cost & Deployment Controls

The solution is intentionally cost-aware:

Feature	Control
Sentinel onboarding	enableSentinel
Baseline analytics rules	deployAnalyticsRules
Advanced detections	deployAdvancedRules
Log retention	Configurable (default 30 days)

This mirrors how security baselines are delivered in real consulting engagements.

Repository Structure
.
├── main.bicep                  # Core RG deployment
├── main.sub.bicep              # Subscription-level activity logs
├── modules/
│   ├── log-analytics.bicep
│   ├── sentinel-onboarding.bicep
│   ├── sentinel-analytics-rules.bicep
│   └── activity-log-to-law.bicep
├── .github/workflows/
│   └── ci-cd.yml               # GitHub Actions pipeline (OIDC)
└── README.md

CI/CD Pipeline Highlights

Uses Azure AD OIDC for secure authentication

No secrets stored in GitHub

Runs what-if before deployment

Fully automated Sentinel onboarding and rule deployment

Designed to be reused across environments

What This Project Demonstrates

Azure security baselining via IaC

Sentinel onboarding without portal dependency

Detections-as-Code for SIEM platforms

CI/CD pipelines for security infrastructure

Enterprise-ready design patterns
