param location string = resourceGroup().location
param workspaceName string = 'law-sec-baseline-dev'
param retentionInDays int = 30

// Toggle: enable/disable Sentinel (cost-aware)
param enableSentinel bool = false

// Toggle: deploy demo analytics rules
param deployAnalyticsRules bool = true

// Core Log Analytics workspace
module logAnalytics './modules/log-analytics.bicep' = {
  name: 'logAnalyticsDeployment'
  params: {
    workspaceName: workspaceName
    location: location
    retentionInDays: retentionInDays
  }
}

// Onboard Microsoft Sentinel (extension resource on the workspace)
module sentinelOnboarding './modules/sentinel-onboarding.bicep' = if (enableSentinel) {
  name: 'sentinelOnboarding'
  params: {
    workspaceName: workspaceName
  }
}

// Deploy sample analytics rules into Sentinel
module sentinelAnalytics './modules/sentinel-analytics-rules.bicep' = if (enableSentinel && deployAnalyticsRules) {
  name: 'sentinelAnalyticsRules'
  params: {
    workspaceName: workspaceName
    deployAnalyticsRules: deployAnalyticsRules
  }
}

output workspaceId string = logAnalytics.outputs.workspaceId
output workspaceCustomerId string = logAnalytics.outputs.workspaceCustomerId

