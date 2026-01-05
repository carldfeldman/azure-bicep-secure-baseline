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
