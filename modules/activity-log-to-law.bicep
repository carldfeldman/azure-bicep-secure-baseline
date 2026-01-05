targetScope = 'subscription'

@description('Resource ID of the Log Analytics Workspace.')
param workspaceId string

@description('Name of the diagnostic setting.')
param diagnosticSettingName string = 'ds-subscription-activitylog-to-law'

resource subActivityLogDiag 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingName
  scope: subscription()
  properties: {
    workspaceId: workspaceId
    logs: [
      { category: 'Administrative', enabled: true }
      { category: 'Security', enabled: true }
      { category: 'ServiceHealth', enabled: true }
      { category: 'Alert', enabled: true }
      { category: 'Recommendation', enabled: true }
      { category: 'Policy', enabled: true }
      { category: 'Autoscale', enabled: true }
      { category: 'ResourceHealth', enabled: true }
    ]
  }
}

