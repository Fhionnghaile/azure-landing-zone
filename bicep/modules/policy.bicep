targetScope = 'subscription'

@description('Tag every resource must carry.')
param requiredTagName string

// Built-in: "Require a tag on resources".
var requireTagDefId = subscriptionResourceId('Microsoft.Authorization/policyDefinitions', '871b6d14-10aa-478d-b590-94f262ecfa99')
// Built-in: "Storage accounts should disable public network access".
var denyStoragePublicDefId = subscriptionResourceId('Microsoft.Authorization/policyDefinitions', 'b2982f36-99f2-4db5-8eff-283140c09693')

resource requireTag 'Microsoft.Authorization/policyAssignments@2024-04-01' = {
  name: 'require-owner-tag'
  properties: {
    displayName: 'Require the owner tag on all resources'
    policyDefinitionId: requireTagDefId
    parameters: {
      tagName: {
        value: requiredTagName
      }
    }
  }
}

resource denyStoragePublic 'Microsoft.Authorization/policyAssignments@2024-04-01' = {
  name: 'deny-storage-public'
  properties: {
    displayName: 'Storage accounts must disable public network access'
    policyDefinitionId: denyStoragePublicDefId
  }
}
