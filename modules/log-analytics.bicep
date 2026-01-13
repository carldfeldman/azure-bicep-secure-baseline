param logAnalyticsName string
param enableDiagnostics bool = true

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsName
}
param workspaceName string
param location string
@minValue(30)
@maxValue(730)
param retentionInDays int = 30

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  properties: {
    retentionInDays: retentionInDays
  }
}

output workspaceId string = workspace.id
output workspaceCustomerId string = workspace.properties.customerId
resource diagSettings 'microsoft.insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${logAnalytics.name}-diag'
  scope: workspace
  properties: {
    workspaceId: workspace.id
    logs: [
      {
        category: 'Audit'
        enabled: true
      }
      {
        category: 'AllLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}
if (enableDiagnostics) {
  resource diagSettings 'microsoft.insights/diagnosticSettings@2021-05-01-preview' = {
    name: '${logAnalyticsName}-diag'
    scope: workspace
    properties: {
      workspaceId: workspace.id
      logs: [
        {
          category: 'Audit'
          enabled: true
        }
        {
          category: 'AllLogs'
          enabled: true
        }
      ]
      metrics: [
        {
          category: 'AllMetrics'
          enabled: true
        }
      ]
    }
  }
}
