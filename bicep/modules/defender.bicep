targetScope = 'subscription'

// Turn on Microsoft Defender for Cloud (Standard tier) for the key plans.
var plans = [
  'VirtualMachines'
  'StorageAccounts'
  'KeyVaults'
  'Containers'
]

resource pricing 'Microsoft.Security/pricings@2024-01-01' = [for plan in plans: {
  name: plan
  properties: {
    pricingTier: 'Standard'
  }
}]
