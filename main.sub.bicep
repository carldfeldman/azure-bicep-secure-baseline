targetScope = 'subscription'

param workspaceId string

module activityLogs './modules/activity-log-to-law.bicep' = {
  name: 'activityLogsToLAW'
  scope: subscription()
  params: {
    workspaceId: workspaceId
  }
}
