// Deploys a small set of lab-focused Sentinel analytics rules into a workspace

@description('Name of the Log Analytics Workspace used by Microsoft Sentinel.')
param workspaceName string

@description('Whether to deploy and enable the sample analytics rules.')
param deployAnalyticsRules bool = true

// Existing workspace that Sentinel is attached to
resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: workspaceName
}

//
// Rule 1: Multiple sign-in failures from the same IP
//
resource ruleMultipleSigninFailures 'Microsoft.SecurityInsights/alertRules@2023-02-01-preview' = if (deployAnalyticsRules) {
  name: 'rule-multiple-signin-failures'
  scope: workspace
  kind: 'Scheduled'
  properties: {
    displayName: 'Multiple sign-in failures from same IP (Lab)'
    description: 'Detects when the same IP generates many failed sign-in attempts in a short time window.'
    enabled: true
    severity: 'Medium'
    query: '''
SigninLogs
| where ResultType != 0
| summarize FailedAttempts = count() by IPAddress = tostring(parse_json(tostring(LocationDetails)).ipAddress), bin(TimeGenerated, 15m)
| where FailedAttempts >= 10
'''
    queryFrequency: 'PT15M'
    queryPeriod: 'PT15M'
    triggerOperator: 'GreaterThan'
    triggerThreshold: 0
    tactics: [
      'CredentialAccess'
    ]
    suppressionDuration: 'PT1H'
    suppressionEnabled: false
  }
}

//
// Rule 2: New user added to privileged directory role
//
resource rulePrivilegedRoleAssignment 'Microsoft.SecurityInsights/alertRules@2023-02-01-preview' = if (deployAnalyticsRules) {
  name: 'rule-privileged-role-assignment'
  scope: workspace
  kind: 'Scheduled'
  properties: {
    displayName: 'New user added to privileged directory role (Lab)'
    description: 'Detects when a user is added to a high-privilege directory role.'
    enabled: true
    severity: 'High'
    query: '''
AuditLogs
| where OperationName contains "Add member to role"
| extend RoleName = tostring(TargetResources[0].displayName)
| where RoleName in~ ("Global Administrator", "Privileged Role Administrator", "Security Administrator")
'''
    queryFrequency: 'PT1H'
    queryPeriod: 'PT1H'
    triggerOperator: 'GreaterThan'
    triggerThreshold: 0
    tactics: [
      'PrivilegeEscalation'
      'Persistence'
    ]
    suppressionDuration: 'PT2H'
    suppressionEnabled: false
  }
}

//
// Rule 3: Suspicious PowerShell usage on servers
//
resource ruleSuspiciousPowerShell 'Microsoft.SecurityInsights/alertRules@2023-02-01-preview' = if (deployAnalyticsRules) {
  name: 'rule-suspicious-powershell'
  scope: workspace
  kind: 'Scheduled'
  properties: {
    displayName: 'Suspicious PowerShell usage (Lab)'
    description: 'Detects potentially suspicious PowerShell command line patterns based on common attacker behaviours.'
    enabled: true
    severity: 'High'
    query: '''
SecurityEvent
| where EventID == 4688
| where Process has "powershell.exe"
| where CommandLine has_any (" -enc ", "IEX(", "DownloadString", "FromBase64String")
'''
    queryFrequency: 'PT15M'
    queryPeriod: 'PT1H'
    triggerOperator: 'GreaterThan'
    triggerThreshold: 0
    tactics: [
      'Execution'
      'DefenseEvasion'
    ]
    suppressionDuration: 'PT1H'
    suppressionEnabled: false
  }
}

