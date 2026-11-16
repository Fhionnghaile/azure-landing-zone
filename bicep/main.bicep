targetScope = 'subscription'

@description('Deployment region.')
param location string = 'eastus'
@description('Name prefix for all resources.')
param prefix string = 'alz'
@description('Tag required on every resource (governance guardrail).')
param requiredTagName string = 'owner'

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: '${prefix}-rg'
  location: location
  tags: {
    '${requiredTagName}': 'platform'
  }
}

module network 'modules/network.bicep' = {
  name: 'network'
  scope: rg
  params: {
    location: location
    prefix: prefix
  }
}

module sentinel 'modules/sentinel.bicep' = {
  name: 'sentinel'
  scope: rg
  params: {
    location: location
    prefix: prefix
  }
}

// Subscription-scoped guardrails.
module policy 'modules/policy.bicep' = {
  name: 'policy'
  params: {
    requiredTagName: requiredTagName
  }
}

module defender 'modules/defender.bicep' = {
  name: 'defender'
}

output workspaceId string = sentinel.outputs.workspaceId
