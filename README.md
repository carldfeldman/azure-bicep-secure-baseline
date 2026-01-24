Azure Sentinel Monitoring Baseline (Bicep)
Overview

This repository implements a lightweight Azure security monitoring baseline using Infrastructure as Code (Bicep). It provisions a Log Analytics Workspace and optionally enables Microsoft Sentinel with detections deployed as code. The goal is to establish an opinionated but extensible foundation suitable for security labs, demonstrations, and portfolio projects.

The solution is intentionally cost-aware and modular, allowing engineers to enable or disable Sentinel components via deployment parameters.

Architecture Components
Component	Purpose
Log Analytics Workspace	Central workspace for platform logs, telemetry, and security data
Microsoft Sentinel (optional)	Enables SIEM capabilities over the workspace
Custom Analytics Rules (optional)	Deployed via IaC to simulate real SOC detection pipelines
Modular Bicep Templates	Encourages reusability and clear separation of concerns
Security Value Proposition

This baseline provides:

Platform-level auditing and telemetry

SIEM enablement without portal-driven configuration

Deterministic deployments via Bicep modules

MITRE ATT&CK-mapped detections as code

Demonstration of SOC pipeline primitives (ingest → analyze → alert)

This makes the project suitable for:

✔ cloud security training
✔ interview demonstration
✔ purple lab environments
✔ IaC + Sentinel integration testing

Sentinel as Code

Sentinel onboarding and rule deployment are implemented as Bicep modules:

Sentinel Onboarding
modules/sentinel-onboarding.bicep


Implements:

Microsoft.SecurityInsights/onboardingStates

Attaches Sentinel to the workspace declaratively (no portal usage)

Custom Analytics Rules
modules/sentinel-analytics-rules.bicep


Deploys 3 scheduled analytics rules mapped to MITRE tactics:

Detection	Use Case	MITRE Tactics
Multiple sign-in failures from same IP	Dictionary / credential spray attempts	Credential Access
New user added to privileged directory roles	Privilege escalation via role assignment	Privilege Escalation / Persistence
Suspicious PowerShell execution	Common attacker execution patterns	Execution / Defense Evasion

These rules are intentionally generic so they can be used in labs without requiring enterprise data sources.

Parameter Controls

Deployment behavior is controlled via two Boolean parameters:

Parameter	Default	Behavior
enableSentinel	false	Enables Sentinel onboarding + workspace integration
deployAnalyticsRules	true	Deploys custom Analytics Rules into Sentinel

Examples:

Enable Sentinel only:

az deployment group create \
  --resource-group <rg> \
  --template-file main.bicep \
  --parameters enableSentinel=true


Enable Sentinel + Rules:

az deployment group create \
  --resource-group <rg> \
  --template-file main.bicep \
  --parameters enableSentinel=true deployAnalyticsRules=true

Deployment Scopes
Scope	Components
Resource Group	Workspace + Sentinel modules
Subscription (optional future extension)	Activity Logs, Defender plans, Policy
Repository Structure
.
├── main.bicep                        # core deployment entrypoint
├── modules/
│   ├── log-analytics.bicep           # workspace setup
│   ├── sentinel-onboarding.bicep     # enables Sentinel via onboardingStates
│   └── sentinel-analytics-rules.bicep# custom detections (MITRE mapped)
├── parameters/
│   └── dev.bicepparam                # example deployment configuration

Cost Considerations

This baseline is designed for labs and demos:

Sentinel disabled by default

30-day retention by default

Minimal ingestion footprint

No premium connectors

No automation charges

No Defender plan enablement

Full SOC workloads (UEBA, Threat Intel, ASC integration, Defender plans, etc.) can be layered atop this baseline if required.

Target Audience

This baseline is intended for:

Cloud Security Engineers

Detection Engineers

SOC Analysts

Security Consultants

Red/Purple Team Labs

Interview Portfolio Demonstrations
