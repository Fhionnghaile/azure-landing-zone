@description('Deployment region.')
param location string
param prefix string

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: '${prefix}-law'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 90
  }
}

// Onboard Microsoft Sentinel onto the workspace.
resource onboard 'Microsoft.SecurityInsights/onboardingStates@2024-03-01' = {
  scope: workspace
  name: 'default'
  properties: {}
}

// Scheduled analytics rule: impossible travel.
resource impossibleTravel 'Microsoft.SecurityInsights/alertRules@2024-03-01' = {
  scope: workspace
  name: guid(workspace.id, 'impossible-travel')
  kind: 'Scheduled'
  properties: {
    displayName: 'Impossible travel (sign-ins)'
    severity: 'High'
    enabled: true
    query: loadTextContent('../../sentinel/hunting/impossible_travel.kql')
    queryFrequency: 'PT1H'
    queryPeriod: 'P1D'
    triggerOperator: 'GreaterThan'
    triggerThreshold: 0
    tactics: [ 'InitialAccess' ]
  }
  dependsOn: [ onboard ]
}

// Scheduled analytics rule: self privilege escalation.
resource privEsc 'Microsoft.SecurityInsights/alertRules@2024-03-01' = {
  scope: workspace
  name: guid(workspace.id, 'priv-esc')
  kind: 'Scheduled'
  properties: {
    displayName: 'Self-granted privileged role'
    severity: 'High'
    enabled: true
    query: loadTextContent('../../sentinel/hunting/privilege_escalation.kql')
    queryFrequency: 'PT1H'
    queryPeriod: 'P1D'
    triggerOperator: 'GreaterThan'
    triggerThreshold: 0
    tactics: [ 'PrivilegeEscalation' ]
  }
  dependsOn: [ onboard ]
}

output workspaceId string = workspace.id
