@description('Deployment region.')
param location string
param prefix string

resource hub 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: '${prefix}-hub'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [ '10.0.0.0/16' ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource spoke 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: '${prefix}-spoke'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [ '10.1.0.0/16' ]
    }
    subnets: [
      {
        name: 'workload'
        properties: {
          addressPrefix: '10.1.0.0/24'
          defaultOutboundAccess: false
        }
      }
    ]
  }
}

resource hubToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: hub
  name: 'to-spoke'
  properties: {
    remoteVirtualNetwork: {
      id: spoke.id
    }
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
  }
}

resource spokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: spoke
  name: 'to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: hub.id
    }
    allowForwardedTraffic: false
    allowVirtualNetworkAccess: true
  }
}

output hubId string = hub.id
output spokeId string = spoke.id
