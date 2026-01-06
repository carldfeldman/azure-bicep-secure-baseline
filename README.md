# Azure Secure Monitoring Baseline (Bicep)

## Overview
This repository implements a secure Azure monitoring baseline using Infrastructure as Code (Bicep).
It centralises Azure subscription Activity Logs into a Log Analytics Workspace to provide
platform-level visibility, auditing, and security telemetry.

The solution is designed to be lightweight, cost-aware, and extensible for future SIEM
and governance controls.

## Architecture
- Log Analytics Workspace (resource-group scope)
- Subscription-wide Activity Log diagnostic settings
- Modular Bicep design with clear separation of scopes

## Security Value
- Auditing of administrative and security actions across the subscription
- Visibility into policy changes, service health, and resource state
- Foundational telemetry for Microsoft Sentinel enablement
- Supports compliance and incident investigation use cases

## Deployment Scopes
- **Resource Group scope**: Core monitoring resources
- **Subscription scope**: Activity Log diagnostic settings

## Cost Considerations
- Log Analytics retention set to 30 days
- Microsoft Sentinel intentionally not enabled by default
- Suitable for development and small production environments

## Repository Structure
```text
.
├── main.bicep
├── main.sub.bicep
├── modules/
│   ├── log-analytics.bicep
│   └── activity-log-to-law.bicep
├── parameters/
│   ├── dev.bicepparam
│   └── dev.sub.bicepparam
