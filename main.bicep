param location string = resourceGroup().location
param workspaceName string
param retentionInDays int = 30

module logAnalytics './modules/log-analytics.bicep' = {
  name: 'logAnalyticsDeployment'
  params: {
    workspaceName: workspaceName
    location: location
    retentionInDays: retentionInDays
  }
}

output workspaceId string = logAnalytics.outputs.workspaceId
output workspaceCustomerId string = logAnalytics.outputs.workspaceCustomerId
